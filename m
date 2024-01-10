Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8656FB1
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 04:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wjrk0BHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD85C433C7;
	Wed, 10 Jan 2024 04:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704862618;
	bh=qCQqYGVm7S7F5KCfFDzt2AAcpRK8k251EmU9e/YV7T8=;
	h=Date:To:From:Subject:From;
	b=wjrk0BHuQzvvPBpiSoAdOTx4Wx9+pHqfubMuCWiQX2Lfyi8AMr6/7wUSVpOtHcDTI
	 tlafKzom4miVe3GCyX6gT0HMWXy7DiVfF0vNSt/HV9kZW7bNzT6fx9JhldiOegefZO
	 yPbV/tG87lP++HijZ7nvW/ffFlIj9ZTiYQdW+Vnk=
Date: Tue, 09 Jan 2024 20:56:58 -0800
To: mm-commits@vger.kernel.org,manivannan.sadhasivam@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-manivannan-sadhasivam.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110045658.CDD85C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Manivannan Sadhasivam
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-manivannan-sadhasivam.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-manivannan-sadhasivam.patch

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
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: mailmap: update entry for Manivannan Sadhasivam
Date: Tue, 09 Jan 2024 15:44:31 +0530

Remove the map for Linaro id as it is still in use and I want to use it
for submitting patches.  Otherwise, git uses kernel.org as the author id
for patches created using Linaro id.

Link: https://lkml.kernel.org/r/20240109-update-mailmap-v1-1-bf7a39f15fb7@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 -
 1 file changed, 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-manivannan-sadhasivam
+++ a/.mailmap
@@ -363,7 +363,6 @@ Maheshwar Ajja <quic_majja@quicinc.com>
 Malathi Gottam <quic_mgottam@quicinc.com> <mgottam@codeaurora.org>
 Manikanta Pubbisetty <quic_mpubbise@quicinc.com> <mpubbise@codeaurora.org>
 Manivannan Sadhasivam <mani@kernel.org> <manivannanece23@gmail.com>
-Manivannan Sadhasivam <mani@kernel.org> <manivannan.sadhasivam@linaro.org>
 Manoj Basapathi <quic_manojbm@quicinc.com> <manojbm@codeaurora.org>
 Marcin Nowakowski <marcin.nowakowski@mips.com> <marcin.nowakowski@imgtec.com>
 Marc Zyngier <maz@kernel.org> <marc.zyngier@arm.com>
_

Patches currently in -mm which might be from manivannan.sadhasivam@linaro.org are

mailmap-update-entry-for-manivannan-sadhasivam.patch

