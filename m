From: akpm@linux-foundation.org
Subject: - make-macfb_setup-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:24 -0700
Message-ID: <200807262118.m6QLIO92020088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757950AbYGZVSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make macfb_setup() static
has been removed from the -mm tree.  Its filename was
     make-macfb_setup-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make macfb_setup() static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global macfb_setup() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/macfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/macfb.c~make-macfb_setup-static drivers/video/macfb.c
--- a/drivers/video/macfb.c~make-macfb_setup-static
+++ a/drivers/video/macfb.c
@@ -596,7 +596,7 @@ static struct fb_ops macfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-void __init macfb_setup(char *options)
+static void __init macfb_setup(char *options)
 {
 	char *this_opt;
 	
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

