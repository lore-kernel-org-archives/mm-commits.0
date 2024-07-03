Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E121C68D
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028969; cv=none; b=U+g1CFt3zYa6q7Fxk7RO2aSP66pwfyg1+SaBme79KiMZIDUIyhazkOSKIx44AopjcGxkwubsAu25zGCx5GvFHXApe39aPnBnu1aTZuJsIC2wurxBilUHGG9hkOt0qBJ9nLQItzRSNSYB7TiZIKA4WEBGjyeq90F2tz9UgdE20Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028969; c=relaxed/simple;
	bh=KYRhZOzEV/oh7Eujc449Cm2YFE1bH9kX8iCSIPsINJg=;
	h=Date:To:From:Subject:Message-Id; b=BivT1WUnKlJ7BqLMQVBSbHPOVHGG5cEGDkPr/YEx4OFHmDgpcVtf+KgbRMZeYmpiDP7sKfsmp4ealHDq+6yNu+u/nleVigJEcqyPlU608XDix8656KS1BI5bhROeU6e/lzbnL0G1BdfygendGTXDtfCY0nwxXNFYbocIzzl3DGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ywo8R4dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ywo8R4dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CA7C2BD10;
	Wed,  3 Jul 2024 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720028969;
	bh=KYRhZOzEV/oh7Eujc449Cm2YFE1bH9kX8iCSIPsINJg=;
	h=Date:To:From:Subject:From;
	b=Ywo8R4dJeC8pEyjldayPA3FC8hj5wb9Prn+vVCAo/mZTQIhWIXlqrIwH5dItPcQ/I
	 EIhYRk+1VEw64p+wZGg6kPUp0+qcIiNuGU87frDsigC7xn8V/VFBx8meWM+rUgaPv/
	 8U1DMn6d47zajcxV1LgBP+kNFLQKC8ufNJ8XRE3Q=
Date: Wed, 03 Jul 2024 10:49:28 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-lorenzo-stoakess-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20240703174929.29CA7C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update Lorenzo Stoakes's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-lorenzo-stoakess-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-lorenzo-stoakess-email-address.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: mailmap: update Lorenzo Stoakes's email address
Date: Wed, 3 Jul 2024 10:27:04 +0100

Now working at Oracle.

Link: https://lkml.kernel.org/r/20240703092704.11571-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-lorenzo-stoakess-email-address
+++ a/.mailmap
@@ -384,6 +384,7 @@ Li Yang <leoyang.li@nxp.com> <leoli@free
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
+Lorenzo Stoakes <lorenzo.stoakes@oracle.com> <lstoakes@gmail.com>
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Luo Jie <quic_luoj@quicinc.com> <luoj@codeaurora.org>
--- a/MAINTAINERS~maintainers-mailmap-update-lorenzo-stoakess-email-address
+++ a/MAINTAINERS
@@ -14473,7 +14473,7 @@ MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
-R:	Lorenzo Stoakes <lstoakes@gmail.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-mailmap-update-lorenzo-stoakess-email-address.patch

