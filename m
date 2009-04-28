From: akpm@linux-foundation.org
Subject: [merged] makefile-make-prepare-should-be-make-modules_prepare.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:25:32 -0700
Message-ID: <200904281925.n3SJPWYw020879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533AbZD1T1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Makefile: "make prepare" should be "make modules_prepare"
has been removed from the -mm tree.  Its filename was
     makefile-make-prepare-should-be-make-modules_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drm-simplify-kcalloc-call-to-kzalloc.patch
kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch

