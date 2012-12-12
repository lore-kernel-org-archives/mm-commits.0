From: akpm@linux-foundation.org
Subject: [merged] avr32-kconfig-remove-have_arch_bootmem.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:15 -0800
Message-ID: <20121212200121.9DF2E200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:33923 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab2LLUBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:01:25 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so64255lah.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:01:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, benh@kernel.crashing.org, egtvedt@samfundet.no, fujita.tomonori@lab.ntt.co.jp, hannes@cmpxchg.org, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32, kconfig: remove HAVE_ARCH_BOOTMEM
has been removed from the -mm tree.  Its filename was
     avr32-kconfig-remove-have_arch_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: avr32, kconfig: remove HAVE_ARCH_BOOTMEM

There is no code for CONFIG_HAVE_ARCH_BOOTMEM, so remove it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/avr32/Kconfig~avr32-kconfig-remove-have_arch_bootmem arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~avr32-kconfig-remove-have_arch_bootmem
+++ a/arch/avr32/Kconfig
@@ -193,9 +193,6 @@ source "kernel/Kconfig.preempt"
 config QUICKLIST
 	def_bool y
 
-config HAVE_ARCH_BOOTMEM
-	def_bool n
