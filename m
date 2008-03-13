From: akpm@linux-foundation.org
Subject: + kerneldoc-for-linux-clkh-fix.patch added to -mm tree
Date: Thu, 13 Mar 2008 13:25:07 -0700
Message-ID: <200803132025.m2DKP75r031273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbYCMU0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 16:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rdunlap@xenotime.net, rmk@arm.linux.org.uk


The patch titled
     kerneldoc-for-linux-clkh fix
has been added to the -mm tree.  Its filename is
     kerneldoc-for-linux-clkh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kerneldoc-for-linux-clkh fix
From: David Brownell <david-b@pacbell.net>

Proof-reading doesn't always cut it ... an editor could help!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~kerneldoc-for-linux-clkh-fix Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kerneldoc-for-linux-clkh-fix
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -671,16 +671,15 @@ X!Idrivers/video/console/fonts.c
 	Power management is supported by explicit software clock gating:
 	unused clocks are disabled, so the system doesn't waste power
 	changing the state of transistors that aren't in active use.
-	On some systems this may be backed by hardware clock gating.
-	Circuits will still have leakage current to be managed, which
-	costs more with finer cicuit geometries, but for CMOS circuits
-	power is mostly spent by clocked state changes.
+	On some systems this may be backed by hardware clock gating,
+	where clocks are gated without being disabled in software.
 	Sections of chips that are powered but not clocked may be able
 	to retain their last state.
 	This low power state is often called a <emphasis>retention
-	mode</emphasis>, in contrast to <emphasis>off</emphasis> where
-	power is cut and no state is retained but where leakage currents
-	may have a significant impact on battery life.
+	mode</emphasis>.
+	This mode still incurs leakage currents, especially with finer
+	circuit geometries, but for CMOS circuits power is mostly used
+	by clocked state changes.
      </para>
 
      <para>
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
au1550_spi-fix-prototype-of-irq-handler.patch
git-acpi.patch
git-avr32.patch
pm-handle-device-registrations-during-suspend-resume.patch
driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

