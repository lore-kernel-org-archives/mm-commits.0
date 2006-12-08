From: akpm@osdl.org
Subject: - struct-path-convert-unix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:21 -0800
Message-ID: <200612082005.kB8K5LlL002289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426319AbWLHUFZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert unix
has been removed from the -mm tree.  Its filename was
     struct-path-convert-unix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert unix
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/unix/garbage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/unix/garbage.c~struct-path-convert-unix net/unix/garbage.c
--- a/net/unix/garbage.c~struct-path-convert-unix
+++ a/net/unix/garbage.c
@@ -96,7 +96,7 @@ atomic_t unix_tot_inflight = ATOMIC_INIT
 static struct sock *unix_get_socket(struct file *filp)
 {
 	struct sock *u_sock = NULL;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	/*
 	 *	Socket ?
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

