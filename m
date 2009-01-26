From: akpm@linux-foundation.org
Subject: [folded] page_fault-retry-with-nopage_retry-fix-3-fix.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:27:45 -0800
Message-ID: <200901261927.n0QJRjPP025840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbZAZT2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, edwintorok@gmail.com, hpa@zytor.com, hugh@veritas.com, lee.schermerhorn@hp.com, mikew@google.com, mingo@el


The patch titled
     page_fault-retry-with-nopage_retry-fix-3-fix
has been removed from the -mm tree.  Its filename was
     page_fault-retry-with-nopage_retry-fix-3-fix.patch

This patch was dropped because it was folded into page_fault-retry-with=
-nopage_retry.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: page_fault-retry-with-nopage_retry-fix-3-fix
=46rom: Andrew Morton <akpm@linux-foundation.org>

undo wrong spelling change.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: T=F6r=F6k Edwin <edwintorok@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/filemap.c~page_fault-retry-with-nopage_retry-fix-3-fix mm/=
filemap.c
--- a/mm/filemap.c~page_fault-retry-with-nopage_retry-fix-3-fix
+++ a/mm/filemap.c
@@ -772,8 +772,7 @@ EXPORT_SYMBOL(find_lock_page);
  *
  * Return *ppage=3D=3DNULL if page is not in pagecache. Otherwise retu=
rn *ppage
  * points to the page in the pagecache with ret=3DVM_FAULT_RETRY indic=
ate a
- * hint to caller for retry, or ret=3D0 which means page is succefully
- * locked.
+ * hint to caller for retry, or ret=3D0 which means page is successful=
ly locked.
  */
 unsigned find_lock_page_retry(struct address_space *mapping, pgoff_t o=
ffset,
 				struct vm_area_struct *vma, struct page **ppage,
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=3Dn.patch
i-need-old-gcc.patch
linux-next.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.p=
atch
x86-define-arch_want_frame_pointers-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-f=
ixes.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-f=
ix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkp=
atch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patc=
h
w1-build-fix.patch
a.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
