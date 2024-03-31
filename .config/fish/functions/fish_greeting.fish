function fish_greeting
    echo "Host:" (uname -a)
    echo "Date:" (date)
    echo
    echo "Disk Usage:"
    dfm
    echo
    echo "Network:"
    ip --brief address show
    echo
end
