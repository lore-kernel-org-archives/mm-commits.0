From: akpm@linux-foundation.org
Subject: + makefile-make-prepare-should-be-make-modules_prepare.patch added to -mm tree
Date: Fri, 24 Apr 2009 13:13:30 -0700
Message-ID: <200904242013.n3OKDWGG006745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967AbZDXUP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, sam@ravnborg.org


The patch titled
     Makefile: "make prepare" should be "make modules_prepare"
has been added to the -mm tree.  Its filename is
     makefile-make-prepare-should-be-make-modules_prepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Makefile: "make prepare" should be "make modules_prepare"
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Correct the Makefile help text to read "make modules_prepare".

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~makefile-make-prepare-should-be-make-modules_prepare Makefile
--- a/Makefile~makefile-make-prepare-should-be-make-modules_prepare
+++ a/Makefile
@@ -1293,7 +1293,7 @@ help:
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[ois]  - Build specified target only'
 	@echo  '  dir/file.ko     - Build module including final link'
-	@echo  '  prepare         - Set up for building external modules'
+	@echo  '  modules_prepare - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
 	@echo  '  kernelrelease	  - Output the release version string'
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
makefile-make-prepare-should-be-make-modules_prepare.patch
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
mm-rewrite-some-tests-with-is_power_of_2-for-clarity.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

