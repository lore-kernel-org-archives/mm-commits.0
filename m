From: akpm@linux-foundation.org
Subject: - consolemap-indentation-braces-disagree-reindent.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:42 -0800
Message-ID: <200901072220.n07MKgoE019932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762391AbZAGWVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     consolemap: indentation & braces disagree - reindent
has been removed from the -mm tree.  Its filename was
     consolemap-indentation-braces-disagree-reindent.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch
linux-next.patch
misdn-indentation-braces-disagree-add-braces.patch
misdn-one-handmade-array_size-converted.patch
misdn-indentation-and-braces-disagree-add-braces.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
