From: akpm@linux-foundation.org
Subject: [merged] lis3-update-maintainer-information.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:13 -0700
Message-ID: <201111012113.pA1LDDxA012097@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29659 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmai


The patch titled
     Subject: lis3: update maintainer information
has been removed from the -mm tree.  Its filename was
     lis3-update-maintainer-information.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>
Subject: lis3: update maintainer information

In the move of the lis3 driver, the hp_accel.c file got dropped from th=
e
MAINTAINER file. Make it explicit again that this file is tied to lis3
again.

Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~lis3-update-maintainer-information MAINTAINERS
--- a/MAINTAINERS~lis3-update-maintainer-information
+++ a/MAINTAINERS
@@ -3995,6 +3995,7 @@ M:	Eric Piel <eric.piel@tremplin-utc.net
 S:	Maintained
 F:	Documentation/misc-devices/lis3lv02d
 F:	drivers/misc/lis3lv02d/
+F:	drivers/platform/x86/hp_accel.c
=20
 LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
