<!DOCTYPE html>
<html>
<head>
    <title>Welcome to IAC4Fun!</title>
</head>
<body>
    <h1>Welcome to IAC4Fun!</h1>
    <?php
    $instance_id = file_get_contents('http://169.254.169.254/latest/meta-data/instance-id');
    $instance_ip = file_get_contents('http://169.254.169.254/latest/meta-data/local-ipv4');
    $availability_zone = file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone');
    $region = substr($availability_zone, 0, -1);
    echo "<p>Instance ID: $instance_id</p>";
    echo "<p>Instance IP: $instance_ip</p>";
    echo "<p>Region: $region</p>";
    echo "<p>Availability Zone: $availability_zone</p>";
    ?>
</body>
</html>

