From: akpm@linux-foundation.org
Subject: - statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:07:39 -0800
Message-ID: <200703060207.l2627edD008919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47286 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965763AbXCFCRx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:17:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jikos@jikos.cz, mp3@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution ia64 fix
has been removed from the -mm tree.  Its filename was
     statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch

This patch was dropped because it was folded into statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch

------------------------------------------------------
Subject: statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution ia64 fix
From: Jiri Kosina <jikos@jikos.cz>

Rename forgotten occurence of ia64_printk_clock to ia64_timestamp_clock

Signed-off-by: Jiri Kosina <jikos@jikos.cz>
Cc: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/sn/kernel/setup.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c~statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix
+++ a/arch/ia64/sn/kernel/setup.c
@@ -67,7 +67,7 @@ extern void bte_init_node(nodepda_t *, c
 extern void sn_timer_init(void);
 extern unsigned long last_time_offset;
 extern int snidle(struct notifier_block *nb, unsigned long state, void *data);
-extern unsigned long long (*ia64_printk_clock)(void);
+extern unsigned long long (*ia64_timestamp_clock)(void);
 
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
_

Patches currently in -mm which might be from jikos@jikos.cz are

bluetooth-hid-quirks-mightymouse-quirk.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution.patch
statistics-infrastructure-make-printk_clock-a-generic-kernel-wide-nsec-resolution-ia64-fix.patch
