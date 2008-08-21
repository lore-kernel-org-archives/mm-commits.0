From: akpm@linux-foundation.org
Subject: + nubus-fix-mis-indented-statement.patch added to -mm tree
Date: Thu, 21 Aug 2008 14:22:37 -0700
Message-ID: <200808212122.m7LLMbL7026621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbYHUVWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 17:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi


The patch titled
     nubus: fix mis-indented statement
has been added to the -mm tree.  Its filename is
     nubus-fix-mis-indented-statement.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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

linux-next.patch
nubus-fix-mis-indented-statement.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
