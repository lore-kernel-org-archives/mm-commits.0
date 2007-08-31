From: akpm@linux-foundation.org
Subject: - maintainers-order-neterion-alphabetically.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:29 -0700
Message-ID: <200708311656.l7VGuTQq017490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbXHaRIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS, order NETERION alphabetically
has been removed from the -mm tree.  Its filename was
     maintainers-order-neterion-alphabetically.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS, order NETERION alphabetically
From: Jiri Slaby <jirislaby@gmail.com>

MAINTAINERS, order NETERION alphabetically

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN MAINTAINERS~maintainers-order-neterion-alphabetically MAINTAINERS
--- a/MAINTAINERS~maintainers-order-neterion-alphabetically
+++ a/MAINTAINERS
@@ -2601,6 +2601,19 @@ M:	shemminger@linux-foundation.org
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 
+NETERION (S2IO) Xframe 10GbE DRIVER
+P:	Ramkrishna Vepa
+M:	ram.vepa@neterion.com
+P:	Rastapur Santosh
+M:	santosh.rastapur@neterion.com
+P:	Sivakumar Subramani
+M:	sivakumar.subramani@neterion.com
+P:	Sreenivasa Honnur
+M:	sreenivasa.honnur@neterion.com
+L:	netdev@vger.kernel.org
+W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/TitleIndex?anonymous
+S:	Supported
+
 NETFILTER/IPTABLES/IPCHAINS
 P:	Rusty Russell
 P:	Marc Boucher
@@ -2741,19 +2754,6 @@ M:	adaplas@gmail.com
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
-NETERION (S2IO) Xframe 10GbE DRIVER
-P:	Ramkrishna Vepa
-M:	ram.vepa@neterion.com
-P:	Rastapur Santosh
-M:	santosh.rastapur@neterion.com
-P:	Sivakumar Subramani
-M:	sivakumar.subramani@neterion.com
-P:	Sreenivasa Honnur
-M:	sreenivasa.honnur@neterion.com
-L:	netdev@vger.kernel.org
-W:	http://trac.neterion.com/cgi-bin/trac.cgi/wiki/TitleIndex?anonymous
-S:	Supported
-
 OPENCORES I2C BUS DRIVER
 P:	Peter Korsgaard
 M:	jacmet@sunsite.dk
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
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
