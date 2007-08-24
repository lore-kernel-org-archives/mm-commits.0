From: akpm@linux-foundation.org
Subject: - x86_64-enable-high-resolution-timers-and-dynticks.patch removed from -mm tree
Date: Fri, 24 Aug 2007 14:47:46 -0700
Message-ID: <200708242147.l7OLlk3R016278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758502AbXHXVsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: enable high resolution timers and dynticks
has been removed from the -mm tree.  Its filename was
     x86_64-enable-high-resolution-timers-and-dynticks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: x86_64: enable high resolution timers and dynticks
From: Chris Wright <chrisw@sous-sol.org>

Everything is in place, enable the HIGHRES andf NO_HZ config options.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/x86_64/Kconfig~x86_64-enable-high-resolution-timers-and-dynticks arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-enable-high-resolution-timers-and-dynticks
+++ a/arch/x86_64/Kconfig
@@ -138,6 +138,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
security-cleanups.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
whitespace-fixes-capability-syscalls.patch
