From: akpm@linux-foundation.org
Subject: [folded] restrict-unprivileged-access-to-kernel-syslog-fix.patch removed from -mm tree
Date: Thu, 11 Nov 2010 13:51:03 -0800
Message-ID: <201011112151.oABLp3YZ004612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab0KKVvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 16:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, drosenberg@vsecurity.com, eugeneteo@kernel.org, kees.cook@canonical.com, mingo@elte.hu, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     restrict-unprivileged-access-to-kernel-syslog-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     restrict-unprivileged-access-to-kernel-syslog-fix.patch

This patch was dropped because it was folded into restrict-unprivileged-access-to-kernel-syslog.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: restrict-unprivileged-access-to-kernel-syslog-checkpatch-fixes-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Eugene Teo <eugeneteo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <kees.cook@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~restrict-unprivileged-access-to-kernel-syslog-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -216,11 +216,14 @@ to decide what to do with it.
 
 dmesg_restrict:
 
-This toggle indicates whether unprivileged users are prevented
-from using dmesg(8) to view messages from the kernel's log
-buffer.  By default, it is set to (0), resulting in no
-restrictions.  When set to (1), users must have CAP_SYS_ADMIN
-to use dmesg(8).
+This toggle indicates whether unprivileged users are prevented from using
+dmesg(8) to view messages from the kernel's log buffer.  When
+dmesg_restrict is set to (0) there are no restrictions.  When
+dmesg_restrict is set set to (1), users must have CAP_SYS_ADMIN to use
+dmesg(8).
+
+The kernel config option CONFIG_SECURITY_DMESG_RESTRICT sets the default
+value of dmesg_restrict.
 
 ==============================================================
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
atomic-add-atomic_inc_not_zero_hint.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
restrict-unprivileged-access-to-kernel-syslog.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-low-threshold-to-pwm-backlight.patch
arch-x86-kernel-entry_32s-work-around-gas-2161-glitch.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch

