From: akpm@linux-foundation.org
Subject: + rtc-parisc-declare-rtc_parisc_dev-as-static.patch added to -mm tree
Date: Mon, 26 Jan 2009 13:50:03 -0800
Message-ID: <200901262150.n0QLo387004080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437AbZAZVvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 16:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, a.zummo@towertech.it, grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx


The patch titled
     rtc-parisc: declare rtc_parisc_dev as static
has been added to the -mm tree.  Its filename is
     rtc-parisc-declare-rtc_parisc_dev-as-static.patch

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
Subject: rtc-parisc: declare rtc_parisc_dev as static
From: dann frazier <dannf@hp.com>

Signed-off-by: dann frazier <dannf@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/kernel/time.c~rtc-parisc-declare-rtc_parisc_dev-as-static arch/parisc/kernel/time.c
--- a/arch/parisc/kernel/time.c~rtc-parisc-declare-rtc_parisc_dev-as-static
+++ a/arch/parisc/kernel/time.c
@@ -216,7 +216,7 @@ void __init start_cpu_itimer(void)
 	per_cpu(cpu_data, cpu).it_value = next_tick;
 }
 
-struct platform_device rtc_parisc_dev = {
+static struct platform_device rtc_parisc_dev = {
 	.name = "rtc-parisc",
 	.id = -1,
 };
_

Patches currently in -mm which might be from dannf@hp.com are

rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi.patch
rtc-add-platform-driver-for-efi-fix.patch
rtc-parisc-add-a-missing-include-for-linux-rtch.patch
rtc-parisc-remove-redundant-locking.patch
rtc-parisc-remove-struct-parisc_rtc.patch
rtc-parisc-use-rtc_valid_tm-in-parisc_get_time.patch
rtc-parisc-use-platform_driver_probe.patch
rtc-parisc-declare-rtc_parisc_dev-as-static.patch
rtc-parisc-remove-unnecessary-ret-variable.patch
rtc-parisc-remove-a-couple-unnecessary-variables.patch
rtc-parisc-rename-p-pointer-to-rtc.patch

