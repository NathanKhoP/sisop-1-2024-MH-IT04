ask_register() {
    echo -e "Welcome to the registration page.\n"

    echo "Enter your email:"
    read email

    if grep -q "^$email:.*:.*:.*:.*" users.txt;
    then
        echo -e "\nEmail already exists. Please choose a different one."
        echo "$(date '+[%d/%m/%y %H:%M:%S]') [REGISTER FAILED] ERROR Failed register attempt with error: "Email already exists": [$email]" >> auth.log
        return 1
    fi

    if [[ $email != *"@"*"."* ]];
    then
        echo -e "\nEmail is invalid."
        echo "$(date '+[%d/%m/%y %H:%M:%S]') [REGISTER FAILED] ERROR Failed register attempt with error: "Email is invalid": [$email]" >> auth.log
        return 1
    fi

    echo "Enter your username:"
    read usr

    echo "Enter a security question, something you will always know:"
    read sec_q
    
    echo "Enter the answer to your security question:"
    read sec_a

    echo "Enter password:"
    read -s pass
    while true; do
        # check more than 8 chars, has at least a capital and a normal letter, has at least a number
        if [[ ${#pass} -ge 8 && "$pass" == *[[:lower:]]* && "$pass" == *[[:upper:]]* && "$pass" == *[0-9]* ]]; 
        then
            echo "Password meets all requirements"
            break
        else
            echo "Password does not meet the requirements"
            echo "Enter password:"
            read -s pass
        fi
    done

    # Add base64 encryption
    enc_pass=$(echo $pass | base64)

    echo "$email:$usr:$sec_q:$sec_a:$enc_pass" >>users.txt
    echo -e "\nRegistration successful\n"
    echo "$(date '+[%d/%m/%y %H:%M:%S]') [REGISTER SUCCESS] user [$usr] registered successfully" >> auth.log
}

ask_register


# date + "%y/%m/%d %H:%M:%S"