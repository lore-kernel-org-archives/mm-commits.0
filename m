From: akpm@osdl.org
Subject: - struct-path-convert-sh.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:02 -0800
Message-ID: <200612082005.kB8K52Kp002256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57427 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426309AbWLHUFI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sh
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sh
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sh/oprofile/op_model_sh7750.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/oprofile/op_model_sh7750.c~struct-path-convert-sh arch/sh/oprofile/op_model_sh7750.c
--- a/arch/sh/oprofile/op_model_sh7750.c~struct-path-convert-sh
+++ a/arch/sh/oprofile/op_model_sh7750.c
@@ -142,7 +142,7 @@ static u64 sh7750_read_counter(int count
  */
 static inline int to_counter(struct file *file)
 {
-	const unsigned char *name = file->f_dentry->d_parent->d_name.name;
+	const unsigned char *name = file->f_path.dentry->d_parent->d_name.name;
 
 	return (int)simple_strtol(name, NULL, 10);
 }
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

