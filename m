From: akpm@linux-foundation.org
Subject: + consolemap-indentation-braces-disagree-reindent.patch added to -mm tree
Date: Tue, 04 Nov 2008 12:27:13 -0800
Message-ID: <200811042027.mA4KRDMx010163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbYKDU1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 15:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi


The patch titled
     consolemap: indentation & braces disagree - reindent
has been added to the -mm tree.  Its filename is
     consolemap-indentation-braces-disagree-reindent.patch

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
Subject: consolemap: indentation & braces disagree - reindent
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/consolemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/consolemap.c~consolemap-indentation-braces-disag=
ree-reindent drivers/char/consolemap.c
--- a/drivers/char/consolemap.c~consolemap-indentation-braces-disagree-=
reindent
+++ a/drivers/char/consolemap.c
@@ -554,7 +554,7 @@ int con_set_unimap(struct vc_data *vc, u
 		__get_user(fontpos, &list->fontpos);
 		if ((err1 =3D con_insert_unipair(p, unicode,fontpos)) !=3D 0)
 			err =3D err1;
-			list++;
+		list++;
 	}
 =09
 	if (con_unify_unimap(vc, p))
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

linux-next.patch
consolemap-indentation-braces-disagree-reindent.patch
misdn-indentation-braces-disagree-add-braces.patch
misdn-one-handmade-array_size-converted.patch
misdn-indentation-and-braces-disagree-add-braces.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
