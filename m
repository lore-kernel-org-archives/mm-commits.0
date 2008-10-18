From: akpm@linux-foundation.org
Subject: - nubus-fix-mis-indented-statement.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:11:23 -0700
Message-ID: <200810182311.m9INBNYD027717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYJRXLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nubus: fix mis-indented statement
has been removed from the -mm tree.  Its filename was
     nubus-fix-mis-indented-statement.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: nubus: fix mis-indented statement
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

It seems this is the right way around because otherwise the len usage i=
n
the outer loop would be pretty pointless.

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nubus/nubus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/nubus/nubus.c~nubus-fix-mis-indented-statement driver=
s/nubus/nubus.c
--- a/drivers/nubus/nubus.c~nubus-fix-mis-indented-statement
+++ a/drivers/nubus/nubus.c
@@ -126,7 +126,7 @@ static void nubus_advance(unsigned char=20
 	{
 		while(not_useful(p,map))
 			p++;
-			p++;
+		p++;
 		len--;
 	}
 	*ptr =3D p;
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
