Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B4D1F4E25
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631915; cv=none; b=pfOGsMz4vdAbUvF5SBzq9XrqQ4lVTra2uimZaa97rjM+OUdCZZVFrHBUJc2Y5ZWftY9+JYsBOhRZIb7ve+Yi5fXB4H26RnOwYZkVmXOKWwnavnMsd73hEyv17rP1tKJlUlIJEd2qkYoQbWAmdRagupBTQnUjfsnQJ16lGVvI+n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631915; c=relaxed/simple;
	bh=bRbOEfM46ASitxKVdMLVTI/kwHKvxaFut0ubrGQPDic=;
	h=Date:To:From:Subject:Message-Id; b=WG8oXT0H7kF1H3gSE0eW01tp5KmFopWHRL8OXT8Ucqb9brczcJ/wE5s+SA8vnCVt8zkJAjpphpzC7oBwGp0zOaazgh4NqiPD97kGSCBgvNGCdbnDGNLhzSiPHjwqPw3x3cAANrXb4wt2hVyfxm1H96txtwc1bUoGKoq3eGHRRsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apzJMjOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apzJMjOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF114C4CEE8;
	Wed,  2 Apr 2025 22:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631915;
	bh=bRbOEfM46ASitxKVdMLVTI/kwHKvxaFut0ubrGQPDic=;
	h=Date:To:From:Subject:From;
	b=apzJMjOXo6qLyOZXlwTwhmkVX9V1JUaDGuLzeD0DEKrSAJB2tnl26jv2JAhicYJ2g
	 Nagh+faVrNlI15wHtJ3GFH2mL7UGXOFPQD2O94flPEuA7KVoZMI6RyCrNWcJcZNEFJ
	 5oGCcafQdn7YB63o10BAkoBednZVr845Wmxfk6Oc=
Date: Wed, 02 Apr 2025 15:11:54 -0700
To: mm-commits@vger.kernel.org,horms@kernel.org,loic.poulain@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-loic-poulains-old-email-addresses.patch added to mm-hotfixes-unstable branch
Message-Id: <20250402221154.DF114C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: map Loic Poulain's old email addresses
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-loic-poulains-old-email-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-loic-poulains-old-email-addresses.patch

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
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Subject: mailmap: map Loic Poulain's old email addresses
Date: Wed, 2 Apr 2025 15:01:37 +0200

Map old email addresses that are no longer in use.

Link: https://lkml.kernel.org/r/20250402130137.12328-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-map-loic-poulains-old-email-addresses
+++ a/.mailmap
@@ -438,6 +438,8 @@ Linus Lüssing <linus.luessing@c0d3.blue
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
+Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@linaro.org>
+Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@intel.com>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> <lstoakes@gmail.com>
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
_

Patches currently in -mm which might be from loic.poulain@oss.qualcomm.com are

mailmap-map-loic-poulains-old-email-addresses.patch

