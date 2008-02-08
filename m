From: akpm@linux-foundation.org
Subject: - mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:42:30 -0800
Message-ID: <200802080842.m188gBwZ016070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbYBHInc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:43:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, urade.masakazu@jp.panasonic.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix
has been removed from the -mm tree.  Its filename was
     mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch

This patch was dropped because it was folded into mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix
From: Andrew Morton <akpm@linux-foundation.org>

Nuke cvs control strings.

Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Masakazu Urade <urade.masakazu@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/boot/tools/build.c |    2 --
 drivers/input/joystick/analog.c |    2 --
 2 files changed, 4 deletions(-)

diff -puN arch/mn10300/boot/tools/build.c~mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix arch/mn10300/boot/tools/build.c
--- a/arch/mn10300/boot/tools/build.c~mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix
+++ a/arch/mn10300/boot/tools/build.c
@@ -1,6 +1,4 @@
 /*
- *  $Id: build.c,v 1.1.2.1 2002/11/12 13:25:46 dhowells Exp $
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 1997 Martin Mares
  */
diff -puN drivers/input/joystick/analog.c~mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix drivers/input/joystick/analog.c
--- a/drivers/input/joystick/analog.c~mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix
+++ a/drivers/input/joystick/analog.c
@@ -1,6 +1,4 @@
 /*
- * $Id: analog.c,v 1.68 2002/01/22 20:18:32 vojtech Exp $
- *
  *  Copyright (c) 1996-2001 Vojtech Pavlik
  */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
