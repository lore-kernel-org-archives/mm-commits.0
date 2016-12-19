From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
 added to -mm tree
Date: Mon, 19 Dec 2016 14:27:15 -0800
Message-ID: <58585ec3.r6xCN292KBNGm1U5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSW0P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:26:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "disassocation" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1887,7 +1887,7 @@ struct cfg80211_deauth_request {
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

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

