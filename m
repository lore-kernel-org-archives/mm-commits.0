Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A5320F
	for <mm-commits@vger.kernel.org>; Sun,  4 Aug 2024 05:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722751020; cv=none; b=ZlvNPSZk6xldp/nWiBiBBa5xDaBQRrsJcnn1Hty3qzPZpcOMSXBgqdFCms7E2n8zdDb3+aUxmDy4KAx61vtDbWBgES6BuXBNrPL83JRX5BjlQF11M4rstoxKNWN5LXxLVGuStnvBJpPd/8CdpQpWsIpmZYFsWVjjGnQYj0R+yFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722751020; c=relaxed/simple;
	bh=nHMi3j+aXKyMYSux1qavcAzrdNWf0/4fiDfkkRPIebo=;
	h=Date:To:From:Subject:Message-Id; b=Dy6fG0zD7dTIkooS07JrGhslV1hRuM8IHTqqdoXokr9gmEaSzxdRJHzFGNfMzmt8NhoOorrFRhLUs+gu5MzM5iHBTgMnb44eBKZf0ZGPWwp0gNWkKY9VHYBiKcadL6l7/VapXIJMQEyaEzang8jIHkXGTuFptrJc8ydGS0S9LTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jB7xEnb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jB7xEnb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D04C32786;
	Sun,  4 Aug 2024 05:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722751020;
	bh=nHMi3j+aXKyMYSux1qavcAzrdNWf0/4fiDfkkRPIebo=;
	h=Date:To:From:Subject:From;
	b=jB7xEnb0/pagApcxNQjTfZrEECVRVPnKwUxd/cp6l9p/j57pX25LKwCuf2w0Zwwjg
	 ysAnznPWyGOLBv2z53KzSixxltoCrhdqjtscYq8cahzAe7NfCepxmYJZCm7KV+HVsU
	 oucJataFlQPnkyKDCNis7rmaiQHo3bAYzRGB+ECM=
Date: Sat, 03 Aug 2024 22:56:59 -0700
To: mm-commits@vger.kernel.org,manivannan.sadhasivam@linaro.org,jikos@kernel.org,davem@davemloft.net,david@ixit.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-david-heidelberg.patch added to mm-hotfixes-unstable branch
Message-Id: <20240804055700.46D04C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for David Heidelberg
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-david-heidelberg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-david-heidelberg.patch

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
From: David Heidelberg <david@ixit.cz>
Subject: mailmap: update entry for David Heidelberg
Date: Sun, 4 Aug 2024 14:45:54 +0900

Link my old gmail address to my active email.

Link: https://lkml.kernel.org/r/20240804054704.859503-1-david@ixit.cz
Signed-off-by: David Heidelberg <david@ixit.cz>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-david-heidelberg
+++ a/.mailmap
@@ -166,6 +166,7 @@ Daniel Borkmann <daniel@iogearbox.net> <
 Daniel Borkmann <daniel@iogearbox.net> <dxchgb@gmail.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
+David Heidelberg <david@ixit.cz> <d.okias@gmail.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@gmail.com>
 David Rheinsberg <david@readahead.eu> <dh.herrmann@googlemail.com>
 David Rheinsberg <david@readahead.eu> <david.rheinsberg@gmail.com>
_

Patches currently in -mm which might be from david@ixit.cz are

mailmap-update-entry-for-david-heidelberg.patch

