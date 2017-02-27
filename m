From: akpm@linux-foundation.org
Subject: [patch 63/78] scripts/spelling.txt: add "disassocation" pattern
 and fix typo instances
Date: Mon, 27 Feb 2017 14:29:42 -0800
Message-ID: <58b4a856.6CMehaC05fbeo33v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdB0Wdi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:33:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "disassocation" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  disassocation||disassociation

Link: http://lkml.kernel.org/r/1481573103-11329-27-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/intel/ipw2x00/ipw2100.c |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c |    2 +-
 include/net/cfg80211.h                       |    2 +-
 scripts/spelling.txt                         |    1 +
 4 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/net/wireless/intel/ipw2x00/ipw2100.c~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances drivers/net/wireless/intel/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5652,7 +5652,7 @@ static void shim__set_security(struct ne
 
 /* As a temporary work around to enable WPA until we figure out why
  * wpa_supplicant toggles the security capability of the driver, which
- * forces a disassocation with force_update...
+ * forces a disassociation with force_update...
  *
  *	if (force_update || !(priv->status & STATUS_ASSOCIATED))*/
 	if (!(priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)))
diff -puN drivers/net/wireless/intel/ipw2x00/ipw2200.c~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances drivers/net/wireless/intel/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3974,7 +3974,7 @@ static void ipw_send_disassociate(struct
 		return;
 	}
 
-	IPW_DEBUG_ASSOC("Disassocation attempt from %pM "
+	IPW_DEBUG_ASSOC("Disassociation attempt from %pM "
 			"on channel %d.\n",
 			priv->assoc_request.bssid,
 			priv->assoc_request.channel);
diff -puN include/net/cfg80211.h~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances include/net/cfg80211.h
--- a/include/net/cfg80211.h~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances
+++ a/include/net/cfg80211.h
@@ -1948,7 +1948,7 @@ struct cfg80211_deauth_request {
  * struct cfg80211_disassoc_request - Disassociation request data
  *
  * This structure provides information needed to complete IEEE 802.11
- * disassocation.
+ * disassociation.
  *
  * @bss: the BSS to disassociate from
  * @ie: Extra IEs to add to Disassociation frame or %NULL
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -364,6 +364,7 @@ differrence||difference
 difinition||definition
 diplay||display
 direectly||directly
+disassocation||disassociation
 disapear||disappear
 disapeared||disappeared
 disappared||disappeared
_
