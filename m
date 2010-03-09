From: akpm@linux-foundation.org
Subject: [merged] rtc-twl-storage-class-should-be-before-const-qualifier.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:32 -0800
Message-ID: <201003091910.o29JAWRf031599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756026Ab0CITWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tklauser@distanz.ch, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-twl: Storage class should be before const qualifier
has been removed from the -mm tree.  Its filename was
     rtc-twl-storage-class-should-be-before-const-qualifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-twl: Storage class should be before const qualifier
From: Tobias Klauser <tklauser@distanz.ch>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning of
the declaration specifiers in a declaration is an obsolescent feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~rtc-twl-storage-class-should-be-before-const-qualifier drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~rtc-twl-storage-class-should-be-before-const-qualifier
+++ a/drivers/rtc/rtc-twl.c
@@ -57,7 +57,7 @@ enum {
 	REG_RTC_COMP_LSB_REG,
 	REG_RTC_COMP_MSB_REG,
 };
-const static u8 twl4030_rtc_reg_map[] = {
+static const u8 twl4030_rtc_reg_map[] = {
 	[REG_SECONDS_REG] = 0x00,
 	[REG_MINUTES_REG] = 0x01,
 	[REG_HOURS_REG] = 0x02,
@@ -80,7 +80,7 @@ const static u8 twl4030_rtc_reg_map[] = 
 	[REG_RTC_COMP_LSB_REG] = 0x10,
 	[REG_RTC_COMP_MSB_REG] = 0x11,
 };
-const static u8 twl6030_rtc_reg_map[] = {
+static const u8 twl6030_rtc_reg_map[] = {
 	[REG_SECONDS_REG] = 0x00,
 	[REG_MINUTES_REG] = 0x01,
 	[REG_HOURS_REG] = 0x02,
_

Patches currently in -mm which might be from tklauser@distanz.ch are

linux-next.patch
cpm_uart-use-resource_size.patch

