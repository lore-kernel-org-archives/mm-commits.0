From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:23 -0700
Message-ID: <55f31987.+jcPyZTK7P6N0/d5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbbIKSMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: make --strict the default for drivers/staging files and patches
has been removed from the -mm tree.  Its filename was
     checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: make --strict the default for drivers/staging files and patches

Making --strict the default for staging may help some people submit
patches without obvious defects.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches
+++ a/scripts/checkpatch.pl
@@ -2174,7 +2174,7 @@ sub process {
 		}
 
 		if ($found_file) {
-			if ($realfile =~ m@^(drivers/net/|net/)@) {
+			if ($realfile =~ m@^(?:drivers/net/|net/|drivers/staging/)@) {
 				$check = 1;
 			} else {
 				$check = $check_orig;
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

