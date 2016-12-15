From: akpm@linux-foundation.org
Subject: [merged] ktestpl-fix-english.patch removed from -mm tree
Date: Thu, 15 Dec 2016 10:46:43 -0800
Message-ID: <5852e513.fiXxS3ioAbovaU6U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756185AbcLOSqx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ktest.pl: fix english
has been removed from the -mm tree.  Its filename was
     ktestpl-fix-english.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


