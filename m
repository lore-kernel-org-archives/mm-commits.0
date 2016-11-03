From: akpm@linux-foundation.org
Subject: + ktestpl-fix-english.patch added to -mm tree
Date: Thu, 03 Nov 2016 15:28:58 -0700
Message-ID: <581bba2a./WaIM2TSDqL7eaex%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932105AbcKCW27 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 18:28:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ktest.pl: fix english
has been added to the -mm tree.  Its filename is
     ktestpl-fix-english.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ktestpl-fix-english.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ktestpl-fix-english.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: ktest.pl: fix english

Ajdust spelling to more common "mandatory".  Variant "mandidory" is
certainly wrong.

Link: http://lkml.kernel.org/r/20161011073003.GA19476@amd
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/ktest/ktest.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN tools/testing/ktest/ktest.pl~ktestpl-fix-english tools/testing/ktest/ktest.pl
--- a/tools/testing/ktest/ktest.pl~ktestpl-fix-english
+++ a/tools/testing/ktest/ktest.pl
@@ -719,14 +719,14 @@ sub set_value {
 
     if ($buildonly && $lvalue =~ /^TEST_TYPE(\[.*\])?$/ && $prvalue ne "build") {
 	# Note if a test is something other than build, then we
-	# will need other manditory options.
+	# will need other mandatory options.
 	if ($prvalue ne "install") {
 	    # for bisect, we need to check BISECT_TYPE
 	    if ($prvalue ne "bisect") {
 		$buildonly = 0;
 	    }
 	} else {
-	    # install still limits some manditory options.
+	    # install still limits some mandatory options.
 	    $buildonly = 2;
 	}
     }
@@ -735,7 +735,7 @@ sub set_value {
 	if ($prvalue ne "install") {
 	    $buildonly = 0;
 	} else {
-	    # install still limits some manditory options.
+	    # install still limits some mandatory options.
 	    $buildonly = 2;
 	}
     }
@@ -3989,7 +3989,7 @@ sub make_min_config {
 		}
 	    }
 
-	    # Save off all the current mandidory configs
+	    # Save off all the current mandatory configs
 	    open (OUT, ">$temp_config")
 		or die "Can't write to $temp_config";
 	    foreach my $config (keys %keep_configs) {
_

Patches currently in -mm which might be from pavel@ucw.cz are

ktestpl-fix-english.patch

