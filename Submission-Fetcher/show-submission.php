<html>

<head>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" crossorigin="anonymous">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.13.1/styles/default.min.css">
    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.13.1/highlight.min.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>

    <script>
        function toggleIcon(e) {
            $(e.target)
                .prev('.panel-heading')
                .find(".more-less")
                .toggleClass('glyphicon-plus glyphicon-minus');
        }
        $('.panel-group').on('hidden.bs.collapse', toggleIcon);
        $('.panel-group').on('shown.bs.collapse', toggleIcon);
    </script>

</head>

<body>

    <?php

        function color_correctness($str) {
            if ($str == 'correct') {
                return "<p style='color: green; font-weight: bold;font-variant: small-caps; display:inline;'>correct</p>";
            } else {
                return "<p style='color: red; font-weight: bold;font-variant: small-caps; display:inline;'>$str</p>";
            }
        }
        
        function decode_problem($str) {
            $name = ['Find the Pair!', 'What’s the Reading?', 'Count', 'Smart Garbage Disposal System', 
                     'Give me Path', 'Calculator', 'Narrow It Down!', 'Linear Regression', 'Prime Test', 'Ahmad’s Tree'];
            $prb_name = $name[ord($str) - ord('A')];
            return "<p style='font-variant: small-caps;display:inline;color: purple; '> " . $str . " - " . $prb_name . " </p>";
        }

        $json = file_get_contents('submission-data.json');
        $json_data = array_reverse(json_decode($json,true));
        
        $i = 0;
        foreach($json_data as $data) {

            $title = "<b>" . $data['Team Name'] . "</b> &nbsp;&nbsp; (" . $data['Language'] . ") 
                     &nbsp;&nbsp; (" . color_correctness($data['Correctness']) . ") 
                     &nbsp;&nbsp; (Time Submission : " . $data['Time Submit'] . ") 
                     &nbsp;&nbsp; (Problem : " . decode_problem($data['Problem Code']) . ")"
            
            ?>

            <div class="container">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                    <div class="panel panel-default">
                        <div class="panel-heading" role="tab" id="heading<?php echo $i; ?>">
                            <h4 class="panel-title">
                                <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse<?php echo $i; ?>"
                                    aria-expanded="true" aria-controls="collapse<?php echo $i; ?>">
                                    <i class="more-less glyphicon glyphicon-plus"></i>
                                    <?php echo $title; ?>
                                </a>
                            </h4>
                        </div>
                        <div id="collapse<?php echo $i; ?>" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading<?php echo $i; ?>">
                            <div class="panel-body">
                                <pre><code><?php echo htmlentities($data['Source Code']); ?></code></pre>
                            </div>
                        </div>
                    </div>
                </div><!-- panel-group -->
            </div><!-- container -->

            <?php

            $i++;
        }
    ?>

    

</body>

</html>