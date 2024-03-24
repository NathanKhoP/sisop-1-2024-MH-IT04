add_user() {
    echo "Enter user email:"
    read email

    if grep -q "^$email:.*:.*:.*:.*" users.txt; 
    then
        echo -e "\nEmail already exists. Please choose a different one."
        echo "$(date '+[%d/%m/%y %H:%M:%S]') [REGISTER FAILED] ERROR Failed register attempt with error: "Email already exists": [$email]" >> auth.log
        return 1
    fi

    if [[ $email != "*@*.*" ]];
    then
        echo -e "\nEmail is invalid."
        echo "$(date '+[%d/%m/%y %H:%M:%S]') [REGISTER FAILED] ERROR Failed register attempt with error: "Email is invalid": [$email]" >> auth.log
        return 1
    fi

    echo "Enter user username:"
    read usr

    echo "Enter a security question, something the user will always know:"
    read sec_q
    
    echo "Enter the answer to your security question:"
    read sec_a

    echo "Enter user password:"
    read -s pass

    enc_pass=$(echo $pass | base64)

    echo "$email:$usr:$sec_q:$sec_a:$enc_pass" >>users.txt
    echo -e "\nRegistration successful\n"
    echo "$(date '+[%d/%m/%y %H:%M:%S]') [REGISTER SUCCESS] user [$usr] registered successfully" >> auth.log
}

edit_user () {
    echo "Enter user email:"
    read email

    if ! grep -q "^$email:.*:.*:.*:.*" users.txt;
    then
        echo -e "\nEmail not found. Please enter a valid email."
        return 1
    else
        echo "Enter new username:"
        read new_usr

        echo "Enter new security question:"
        read new_sec_q

        echo "Enter new security answer:"
        read new_sec_a

        echo "Enter new password:"
        read -s new_pass
        
        newenc_pass=$(echo $new_pass | base64)

        # replace the existing line with the new values
        sed -i "/^$email:/c\\$email:$new_usr:$new_sec_q:$new_sec_a:$newenc_pass" users.txt
        echo -e "\nEdit successful\n"
    fi
}

delete_user () {
    echo "Enter user email:"
    read email

    if ! grep -q "^$email:" users.txt;
    then
        echo -e "\nEmail not found. Please enter a valid email."
        return 1
    else
        # delete the line
        sed -i "/^$email:/d" users.txt
        echo -e "\nDelete successful\n"
    fi
}

admin () {
    echo "Welcome! You currently have admin privileges."
    while true; do
        echo "Admin Menu"
        echo "1. Add User"
        echo "2. Edit User"
        echo "3. Delete User"
        echo -e "4. Exit \n"
        
        echo "Choose an option: "
        read choice

        case $choice in
        1) add_user ;;
        2) edit_user ;;
        3) delete_user ;;
        4) 
            echo "Exiting..."
            break
            ;;
        *) echo "Invalid choice" ;;
        esac
    done
}

member () {
    echo "Welcome! You currently have member privileges."
}

ask_login () {
    echo "Enter your email:"
    read email

    if ! grep -q "^$email:" users.txt;
    then    
        echo -e "\nEmail not found. Please enter a valid email."
        return 1
    else    
        echo "Enter password:"
        read -s pass

        usr=$(grep "^$email:" users.txt | cut -d':' -f2)
        enc_pass=$(echo $pass | base64)

        if grep -q "^$email:.*:.*:.*:$enc_pass" users.txt && [[ $email == *"admin"* ]]
        then    
            echo -e "\nLogin successful\n"
            echo "$(date '+[%d/%m/%y %H:%M:%S]') [LOGIN SUCCESS] user [$usr] logged in successfully" >> auth.log
            admin
        elif grep -q "^$email:.*:.*:.*:$enc_pass" users.txt;
        then
            echo -e "\nLogin successful\n"
            echo "$(date '+[%d/%m/%y %H:%M:%S]') [LOGIN SUCCESS] user [$usr] logged in successfully" >> auth.log
            member
        else
            echo -e "\nPassword is incorrect. Please enter the correct password."
            echo "$(date '+[%d/%m/%y %H:%M:%S]') [LOGIN FAILED] ERROR Failed login attempt on user with email [$email]" >> auth.log
            return 1  
        fi
    fi
}

ask_forgot () {
    echo "Enter your email:"
    read email

    if ! grep -q "^$email:" users.txt;
    then
        echo -e "\nEmail not found. Please enter a valid email."
        return 1
    else
        # grep the correct sec_q and _a from email
        sec_q=$(grep "^$email:" users.txt | cut -d':' -f3)
        echo "Security question: $sec_q"

        echo "Enter your answer:"
        read sec_a

        if ! grep -q "^$email:.*:.*:$sec_a" users.txt;
        then
            echo -e "\nAnswer is incorrect. Please enter the correct answer."
            return 1
        else
            enc_pass=$(grep "^$email:" users.txt | cut -d':' -f5)
            pass=$(echo $enc_pass | base64 -d)
            echo -e "\nYour password is: $pass\n"

            # Extra mechanism for a new password
            # echo "Enter new password:"  
            # read -s new_pass
            # enc_pass=$(echo $new_pass | base64)

            # # echo "$email:$new_pass" >>users.txt
            # sed -i "/^$email:/ s/^\([^:]*\):\([^:]*\):\([^:]*\):\([^:]*\):[^:]*$/\1:\2:\3:\4:$enc_pass/" users.txt
            # echo -e "\nPassword reset successful\n"
        fi
    fi
}

welcome () {
    echo "Welcome to the login page. Please select an option:"
    echo "1. Login"
    echo "2. Forgot Password"
    echo "Choose an option: "
    read choice

    case $choice in
    1) ask_login ;;
    2) ask_forgot ;;
    *) echo "Invalid choice" ;;
    esac
}

welcome

# date + "%y/%m/%d %H:%M:%S"
