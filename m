Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9512F18EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W5isxaQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEE4C433C7;
	Fri, 12 Jan 2024 23:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101698;
	bh=amMTs7GdnyqfjO565pxz2HhtcRAb01zNNc+DzOCMylM=;
	h=Date:To:From:Subject:From;
	b=W5isxaQkKUOx1gMbOcC3XAzBgO06N2d3J20BM/9Kbu6XQqGjmWKCSXFJeadDoBVrg
	 QqCqG3VELrmCAb+JGWb3H/CV9odKejwxueAlafb4AcpFRdiST1wfPoh5ZY//8zK/XK
	 bkUK1Y/eREO3cTOAsbZCNuu18oV1Z4mnPFVMaiks=
Date: Fri, 12 Jan 2024 15:21:37 -0800
To: mm-commits@vger.kernel.org,manivannan.sadhasivam@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-manivannan-sadhasivam.patch removed from -mm tree
Message-Id: <20240112232138.0EEE4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Manivannan Sadhasivam
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-manivannan-sadhasivam.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


