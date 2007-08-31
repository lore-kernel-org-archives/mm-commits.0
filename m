From: akpm@linux-foundation.org
Subject: - net-ath5k-use-short-preamble-for-some-rates.patch removed from -mm tree
Date: Thu, 30 Aug 2007 23:35:01 -0700
Message-ID: <200708310635.l7V6Z1Zn027744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759115AbXHaGgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 02:36:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Net: ath5k, use short preamble for some rates
has been removed from the -mm tree.  Its filename was
     net-ath5k-use-short-preamble-for-some-rates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Net: ath5k, use short preamble for some rates
From: Jiri Slaby <jirislaby@gmail.com>

ath5k, use short preamble for some rates

2, 5.5 and 11 in b/g are now in short preamble mode

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/wireless/ath5k.h~net-ath5k-use-short-preamble-for-some-rates drivers/net/wireless/ath5k.h
--- a/drivers/net/wireless/ath5k.h~net-ath5k-use-short-preamble-for-some-rates
+++ a/drivers/net/wireless/ath5k.h
@@ -613,9 +613,9 @@ struct ath5k_rate_table {
 	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	3, 2, 1, 0, 255, 255, 255, 255 }, {				\
 	{ 1, MODULATION_CCK, 1000, 27, 130, 0 },	\
-	{ 1, MODULATION_CCK, 2000, 26, 132, 1 },	\
-	{ 1, MODULATION_CCK, 5500, 25, 139, 1 },	\
-	{ 1, MODULATION_CCK, 11000, 24, 150, 1 } }	\
+	{ 1, MODULATION_CCK_SP, 2000, 26, 132, 1 },	\
+	{ 1, MODULATION_CCK_SP, 5500, 25, 139, 1 },	\
+	{ 1, MODULATION_CCK_SP, 11000, 24, 150, 1 } }	\
 }
 
 #define AR5K_RATES_11G { 12, {					\
@@ -623,9 +623,9 @@ struct ath5k_rate_table {
 	11, 9, 7, 5, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	3, 2, 1, 0, 255, 255, 255, 255 }, {			\
 	{ 1, MODULATION_CCK, 1000, 27, 2, 0 },		\
-	{ 1, MODULATION_CCK, 2000, 26, 4, 1 },		\
-	{ 1, MODULATION_CCK, 5500, 25, 11, 1 },		\
-	{ 1, MODULATION_CCK, 11000, 24, 22, 1 },	\
+	{ 1, MODULATION_CCK_SP, 2000, 26, 4, 1 },		\
+	{ 1, MODULATION_CCK_SP, 5500, 25, 11, 1 },		\
+	{ 1, MODULATION_CCK_SP, 11000, 24, 22, 1 },	\
 	{ 0, MODULATION_OFDM, 6000, 11, 12, 4 },	\
 	{ 0, MODULATION_OFDM, 9000, 15, 18, 4 },	\
 	{ 1, MODULATION_OFDM, 12000, 10, 24, 6 },	\
_

Patches currently in -mm which might be from jirislaby@gmail.com are

maintainers-order-neterion-alphabetically.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
ata-pata_marvell-use-ioread-for-iomap-ped-memory.patch
git-net.patch
git-wireless.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
shrink_slab-handle-bad-shrinkers.patch
