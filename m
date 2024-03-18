Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1584779F
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788424; cv=none; b=Iu+7IicfwmSEfeV7k/LvSE/Olk7of2WFZwIQ1Vqg67VesJ41WorK2qplPDga1QGLDexz7jrBSUBB2MNBo1a6gU8D1sjkAIRfpx4ZEiIWVl8z4GlS0bniKBapQxdXpwHT1RwMp6+TZ3ERCEbtHIfmq79rlAfKqBeomDaSt1sD7ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788424; c=relaxed/simple;
	bh=RyrvFVf05h2YYeZgZW58k1+m3/6LbdiQbMfanTflYOM=;
	h=Date:To:From:Subject:Message-Id; b=QxtiQKPhG3s5nMchyWUVHYNvZAhD1VBCE6pCx67l7V+/ggnl8rlM/DUmUKpBbP0t1ULK7/MMmB30k2CyNph7xQ6tpKIDYmJEjQzpxnrBtTOME02bw+Zq87zNmu3VXek3ra/NY6Ie/fmhX1MU3Jif3PzLuEeOG3YlL0wMeKfs7aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJ+oJXcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJ+oJXcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90467C433C7;
	Mon, 18 Mar 2024 19:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788424;
	bh=RyrvFVf05h2YYeZgZW58k1+m3/6LbdiQbMfanTflYOM=;
	h=Date:To:From:Subject:From;
	b=JJ+oJXcvrYe88lya6bFpLK2pOw//yo7/viooRFNd59ovEbG5O3GHnvqq0B72VynaW
	 wARDf1wRpr8iYLZ3lf6DDQkLC5OTaZGVIQDo8rzGDg8w4R1hJzfSANgzFQ7GFa2j1n
	 Ac5Pu16h61uB1BPGWyVVPLjmcw4wUG6pu6N+wHa0=
Date: Mon, 18 Mar 2024 12:00:24 -0700
To: mm-commits@vger.kernel.org,f.fainelli@gmail.com,cdleonard@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-leonard-crestez.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318190024.90467C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Leonard Crestez
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-leonard-crestez.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-leonard-crestez.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Leonard Crestez <cdleonard@gmail.com>
Subject: mailmap: update entry for Leonard Crestez
Date: Sat, 16 Mar 2024 20:28:37 +0200

Put my personal email first because NXP employment ended some time ago.
Also add my old intel email address.

Link: https://lkml.kernel.org/r/f568faa0-2380-4e93-a312-b80c1e367645@gmail.com
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-leonard-crestez
+++ a/.mailmap
@@ -340,7 +340,8 @@ Lee Jones <lee@kernel.org> <joneslee@goo
 Lee Jones <lee@kernel.org> <lee.jones@canonical.com>
 Lee Jones <lee@kernel.org> <lee.jones@linaro.org>
 Lee Jones <lee@kernel.org> <lee@ubuntu.com>
-Leonard Crestez <leonard.crestez@nxp.com> Leonard Crestez <cdleonard@gmail.com>
+Leonard Crestez <cdleonard@gmail.com> <leonard.crestez@nxp.com>
+Leonard Crestez <cdleonard@gmail.com> <leonard.crestez@intel.com>
 Leonardo Bras <leobras.c@gmail.com> <leonardo@linux.ibm.com>
 Leonard Göhrs <l.goehrs@pengutronix.de>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
_

Patches currently in -mm which might be from cdleonard@gmail.com are

mailmap-update-entry-for-leonard-crestez.patch

