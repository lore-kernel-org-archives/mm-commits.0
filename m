From: akpm@linux-foundation.org
Subject: + config_hp_accel-fix-help-text.patch added to -mm tree
Date: Mon, 01 Aug 2011 13:29:44 -0700
Message-ID: <201108012029.p71KTjK6012311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab1HAUad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2011 16:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmail.com


The patch titled
     CONFIG_HP_ACCEL: fix help text
has been added to the -mm tree.  Its filename is
     config_hp_accel-fix-help-text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: CONFIG_HP_ACCEL: fix help text
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>

Adapt the help text for CONFIG_HP_ACCEL to the move of
Documentation/hwmon/lis3lv02d to Documentation/misc-devices/ in
ff606677f6a47c63329cf8e6c7cf978c29f2d736 ("Move lis3lv02d drivers to
drivers/misc").

Signed-off-by: Malte Starostik <m-starostik@versanet.de>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/Kconfig~config_hp_accel-fix-help-text dr=
ivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~config_hp_accel-fix-help-text
+++ a/drivers/platform/x86/Kconfig
@@ -164,7 +164,7 @@ config HP_ACCEL
=20
 	  Support for a led indicating disk protection will be provided as
 	  hp::hddprotect. For more information on the feature, refer to
-	  Documentation/hwmon/lis3lv02d.
+	  Documentation/misc-devices/lis3lv02d.
=20
 	  To compile this driver as a module, choose M here: the module will
 	  be called hp_accel.
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch
lis3-update-maintainer-information.patch
lis3-add-support-for-hp-elitebook-2730p.patch
lis3-add-support-for-hp-elitebook-8540w.patch
hp_accel-add-hp-probook-655x.patch
config_hp_accel-fix-help-text.patch
lis3-free-regulators-if-probe-fails.patch
lis3-change-naming-to-consistent.patch
lis3-change-exported-function-to-use-given.patch
lis3-remove-the-references-to-the-global-variable-in-core-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
