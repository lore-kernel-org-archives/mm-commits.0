From: akpm@linux-foundation.org
Subject: - ipwireless-use-ansi-func-decl.patch removed from -mm tree
Date: Thu, 22 Mar 2007 12:21:32 -0800
Message-ID: <200703222021.l2MKLWfJ029468@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934223AbXCVUVk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 16:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     ipwireless: use ANSI func. decl.
has been removed from the -mm tree.  Its filename was
     ipwireless-use-ansi-func-decl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipwireless: use ANSI func. decl.
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function declaration:
drivers/char/pcmcia/ipwireless_cs_tty.c:730:29: warning: non-ANSI function declaration of function 'ipwireless_tty_release'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/ipwireless_cs_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/pcmcia/ipwireless_cs_tty.c~ipwireless-use-ansi-func-decl drivers/char/pcmcia/ipwireless_cs_tty.c
--- a/drivers/char/pcmcia/ipwireless_cs_tty.c~ipwireless-use-ansi-func-decl
+++ a/drivers/char/pcmcia/ipwireless_cs_tty.c
@@ -727,7 +727,7 @@ int ipwireless_tty_init(int major)
 	return 0;
 }
 
-void ipwireless_tty_release()
+void ipwireless_tty_release(void)
 {
 	int ret, loops = 0;
 	remove_proc_entry(IPWIRELESS_PCCARD_NAME, &proc_root);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
cpuidle-unsigned-bitfield.patch
acpi-dock-use-null-for-pointer.patch
nozomi-use-null-for-pointers.patch
git-drm.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
