From: akpm@linux-foundation.org
Subject: [folded-dropped] fs-proc-clean-up-printks-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:39:54 -0800
Message-ID: <20130228003954.D637831C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45057 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1Ajz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:39:55 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so139978yhr.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:39:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-clean-up-printks-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-clean-up-printks-fix.patch

This patch was dropped because it was folded into fs-proc-clean-up-printks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-clean-up-printks-fix

grr

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/vmcore.c~fs-proc-clean-up-printks-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-clean-up-printks-fix
+++ a/fs/proc/vmcore.c
@@ -554,7 +554,7 @@ static int __init parse_crash_elf64_head
 		ehdr.e_ehsize != sizeof(Elf64_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf64_Phdr) ||
 		ehdr.e_phnum == 0) {
-		pr_warning("Warning: Core image elf header is not sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 
@@ -609,7 +609,7 @@ static int __init parse_crash_elf32_head
 		ehdr.e_ehsize != sizeof(Elf32_Ehdr) ||
 		ehdr.e_phentsize != sizeof(Elf32_Phdr) ||
 		ehdr.e_phnum == 0) {
-		pr_warning("Warning: Core image elf header is not sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 
@@ -652,7 +652,7 @@ static int __init parse_crash_elf_header
 	if (rc < 0)
 		return rc;
 	if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
-		pr_warning("Warning: Core image elf header not found\n");
+		pr_warn("Warning: Core image elf header not found\n");
 		return -EINVAL;
 	}
 
@@ -671,7 +671,7 @@ static int __init parse_crash_elf_header
 		/* Determine vmcore size. */
 		vmcore_size = get_vmcore_size_elf32(elfcorebuf);
 	} else {
-		pr_warning("Warning: Core image elf header is not sane\n");
+		pr_warn("Warning: Core image elf header is not sane\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -687,7 +687,7 @@ static int __init vmcore_init(void)
 		return rc;
 	rc = parse_crash_elf_headers();
 	if (rc) {
-		pr_warning("Kdump: vmcore not initialized\n");
+		pr_warn("Kdump: vmcore not initialized\n");
 		return rc;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

