Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604078F5B
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 01:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742435932; cv=none; b=VcZp1b+ee2lsz7pJg3QaLGHhSKM3+QjNDXnV6haavAydAR8vBurxC3QdmpnliI48i7gdZO9mkRyBDgaRit/Q2OVfhMWXPpbTLjG+p38tYmom7KS6a45VKxpZ+clfCyajx+qYRaM6Ku0XzQwhCHlQSahinZHq3+6JvK2ukpsoANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742435932; c=relaxed/simple;
	bh=QW1OFak4qZbqOb5JzNtguQcxqkMbcZHlYRnR/F0d/Vs=;
	h=Date:To:From:Subject:Message-Id; b=n9RkHVUXfsUprxXDFAuWFZfXViM6GWYzIOzZgMuJXz8NsWs3g1uKsyFOOAxwjDrZa7AyFEDL6hrn9OIP6J/R0wLK9xD/VlyMxHkjoaHmX4t1+vyObo0KQKB/AvBXBQWBDxUS5eFC8dj0rjDOu6ApwzthAvUpbft3yZea5soUsl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K5ZEF6sB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K5ZEF6sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09428C4CEE4;
	Thu, 20 Mar 2025 01:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742435932;
	bh=QW1OFak4qZbqOb5JzNtguQcxqkMbcZHlYRnR/F0d/Vs=;
	h=Date:To:From:Subject:From;
	b=K5ZEF6sBSNDZ1GenyKZfPAgRpfua1fn4BDh7F7p7uUCIBZ5fG5TbRimZs3j52qVdX
	 Qq/eO9d6lnsJTVVeFzAvzdy7BaC1XIubHLIoazuIslo/Nz/BN6QGOofXaULNYesj8H
	 u67iIBF0ArYa3eWFs6Bwbx0qsJ7VHK017ZlZ5Yd8=
Date: Wed, 19 Mar 2025 18:58:51 -0700
To: mm-commits@vger.kernel.org,alexander.sverdlin@siemens.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-consolidate-email-addresses-of-alexander-sverdlin.patch added to mm-nonmm-unstable branch
Message-Id: <20250320015852.09428C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: consolidate email addresses of Alexander Sverdlin
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-consolidate-email-addresses-of-alexander-sverdlin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-consolidate-email-addresses-of-alexander-sverdlin.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Subject: mailmap: consolidate email addresses of Alexander Sverdlin
Date: Wed, 19 Mar 2025 09:52:46 +0100

Alias all the addresses used in the past and currently to the single
contact address.

Link: https://lkml.kernel.org/r/20250319085251.3335678-1-alexander.sverdlin@siemens.com
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/.mailmap~mailmap-consolidate-email-addresses-of-alexander-sverdlin
+++ a/.mailmap
@@ -31,6 +31,13 @@ Alexander Lobakin <alobakin@pm.me> <alob
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin.ext@nsn.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@gmx.de>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nokia.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nsn.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@siemens.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@sysgo.com>
+Alexander Sverdlin <alexander.sverdlin@gmail.com> <subaparts@yandex.ru>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
 Alexandre Ghiti <alex@ghiti.fr> <alexandre.ghiti@canonical.com>
 Alexei Avshalom Lazar <quic_ailizaro@quicinc.com> <ailizaro@codeaurora.org>
_

Patches currently in -mm which might be from alexander.sverdlin@siemens.com are

mailmap-consolidate-email-addresses-of-alexander-sverdlin.patch

