From: akpm@linux-foundation.org
Subject: + lis3-add-support-for-the-hp-elitebook-8530w.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:43:33 -0700
Message-ID: <200910162143.n9GLhY33018745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZJPVns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, jorgen.jonsson@saitek.se, pavel@ucw.cz


The patch titled
     lis3: add support for the HP EliteBook 8530w
has been added to the -mm tree.  Its filename is
     lis3-add-support-for-the-hp-elitebook-8530w.patch

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
Subject: lis3: add support for the HP EliteBook 8530w
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>

Correct orientation for  HP EliteBook 8530w.

Reported-by: J=C3=B6rgen Jonssson <jorgen.jonsson@saitek.se>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/hwmon/hp_accel.c~lis3-add-support-for-the-hp-eliteboo=
k-8530w drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~lis3-add-support-for-the-hp-elitebook-85=
30w
+++ a/drivers/hwmon/hp_accel.c
@@ -203,6 +203,7 @@ static struct dmi_system_id lis3lv02d_dm
 	AXIS_DMI_MATCH("NC6710x", "HP Compaq 6710", xy_swap_yz_inverted),
 	AXIS_DMI_MATCH("NC6715x", "HP Compaq 6715", y_inverted),
 	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 693", xy_rotated_right),
+	AXIS_DMI_MATCH("NC693xx", "HP EliteBook 853", xy_swap),
 	/* Intel-based HP Pavilion dv5 */
 	AXIS_DMI_MATCH2("HPDV5_I",
 			PRODUCT_NAME, "HP Pavilion dv5",
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

linux-next.patch
lis3-better-support-for-hp-6730x.patch
lis3-add-support-for-the-hp-elitebook-8530w.patch
lis3-add-support-for-the-hp-hdx-18.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
