From: akpm@linux-foundation.org
Subject: [merged] lis3-add-support-for-hp-elitebook-8540w.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:24 -0700
Message-ID: <201111012113.pA1LDOWw025327@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmai


The patch titled
     Subject: lis3: add support for HP EliteBook 8540w
has been removed from the -mm tree.  Its filename was
     lis3-add-support-for-hp-elitebook-8540w.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>
Subject: lis3: add support for HP EliteBook 8540w

Add axis correction for HP EliteBook 8540w.

Reported-by: Lyall Pearce <lyall.pearce@hp.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/hp_accel.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/hp_accel.c~lis3-add-support-for-hp-elite=
book-8540w drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~lis3-add-support-for-hp-elitebook=
-8540w
+++ a/drivers/platform/x86/hp_accel.c
@@ -209,6 +209,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
+	AXIS_DMI_MATCH("NC854xx", "HP EliteBook 854", y_inverted),
 	AXIS_DMI_MATCH("NC273xx", "HP EliteBook 273", y_inverted),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
