From: akpm@linux-foundation.org
Subject: + pavel.patch added to -mm tree
Date: Mon, 12 Jan 2009 12:53:33 -0800
Message-ID: <200901122053.n0CKrXuo010375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840AbZALUxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 15:53:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, pavel@suse.cz


The patch titled
     pavel
has been added to the -mm tree.  Its filename is
     pavel.patch

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
Subject: pavel
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Makefile~pavel Makefile
--- a/Makefile~pavel
+++ a/Makefile
@@ -4,6 +4,8 @@ SUBLEVEL = 29
 EXTRAVERSION = -rc1
 NAME = Erotic Pickled Herring
 
+bite me!
+
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
 # More info can be located in ./README
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
clocksource-pass-clocksource-to-read-callback.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
smp_call_function_single-be-slightly-less-stupid.patch
kernel-trace-ring_bufferc-reduce-inlining.patch
kernel-trace-ring_bufferc-use-div_round_up.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch
pavel.patch

