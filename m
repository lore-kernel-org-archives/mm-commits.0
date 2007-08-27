From: akpm@linux-foundation.org
Subject: + maintainers-order-neterion-alphabetically.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:57:35 -0700
Message-ID: <200708272157.l7RLvZsY030540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965308AbXH0V5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     MAINTAINERS, order NETERION alphabetically
has been added to the -mm tree.  Its filename is
     maintainers-order-neterion-alphabetically.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS, order NETERION alphabetically
From: Jiri Slaby <jirislaby@gmail.com>

MAINTAINERS, order NETERION alphabetically

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff -puN MAINTAINERS~maintainers-order-neterion-alphabetically MAINTAINERS
--- a/MAINTAINERS~maintainers-order-neterion-alphabetically
+++ a/MAINTAINERS
@@ -2666,6 +2666,19 @@ M:	shemminger@linux-foundation.org
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
@@ -2800,19 +2813,6 @@ M:	adaplas@gmail.com
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

maintainers-order-neterion-alphabetically.patch
git-wireless.patch
net-ath5k-comment-some-eeprom-registers.patch
net-ath5k-initial-write-cleanup.patch
net-ath5k-use-short-preamble-for-some-rates.patch
net-ath5k-remove-some-ieee80211-re-defines.patch
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
shrink_slab-handle-bad-shrinkers.patch
