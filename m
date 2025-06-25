Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CC2217707
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892161; cv=none; b=ERcPWwVIIzY4/z++4YiB3by77wPaHj3AuT+jywCE5t+kzgb79ngPsXDNxmU9Y8i9dH5AFfC06VviEam+CgfUve/+ds989brFl66l/aosp/ZmWdewPG9zUaRTYlivvflksxa93jixUXJXKqokH9FO5KRo8hnLom6YS3g1duxBeK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892161; c=relaxed/simple;
	bh=DtEmyuVMkBhn8mIJhj7vRcf+Wygk7TRRt4hmPyx0xNY=;
	h=Date:To:From:Subject:Message-Id; b=PriJJHwNr4LRiO19kMoZ0j6hS7VYRmh9ecX2ZMPpluADQ5KnbX3zYqj8YUqjUWt5JKjg+Ysxc1RUfGlRgqL1ySUBuT315+h/PdLlbDW8MoyMv8zIj/5VcZW0aNwVjrtPWEfTnBewZI9OPYOi0/luhZPFN8AbzNEzTjJaxpi7ywU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USz5AkCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USz5AkCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46ACFC4CEEA;
	Wed, 25 Jun 2025 22:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892161;
	bh=DtEmyuVMkBhn8mIJhj7vRcf+Wygk7TRRt4hmPyx0xNY=;
	h=Date:To:From:Subject:From;
	b=USz5AkCq5x8LRMe7mHSChsXX4RFKpajym8WslsjkqzMWbdZYgZ2OrBHgLVDWgQ4ed
	 pRyqEOu7yk0sCI2eV8R/5RL2Y/ygRoioNCbRVVBRKjqNDTIPfjbAcJvt10r9qz0Rjk
	 75xTurlLbO8QH4MqFxjnWFErOtkOafFi4+2q87Gk=
Date: Wed, 25 Jun 2025 15:56:00 -0700
To: mm-commits@vger.kernel.org,hverkuil@xs4all.nl,zijun.hu@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-zijun-hu.patch removed from -mm tree
Message-Id: <20250625225601.46ACFC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entries for Zijun Hu
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-zijun-hu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zijun Hu <zijun.hu@oss.qualcomm.com>
Subject: mailmap: add entries for Zijun Hu
Date: Fri, 20 Jun 2025 19:53:53 +0800

Map my old qualcomm email addresses:
	Zijun Hu <quic_zijuhu@quicinc.com>
	Zijun Hu <zijuhu@codeaurora.org>
To the current one:
	Zijun Hu <zijun.hu@oss.qualcomm.com>

Link: https://lkml.kernel.org/r/20250620-my_mailmap-v1-1-11ea3db8ba1e@oss.qualcomm.com
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Cc: Hans verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-zijun-hu
+++ a/.mailmap
@@ -830,3 +830,5 @@ Yosry Ahmed <yosry.ahmed@linux.dev> <yos
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
+Zijun Hu <zijun.hu@oss.qualcomm.com> <quic_zijuhu@quicinc.com>
+Zijun Hu <zijun.hu@oss.qualcomm.com> <zijuhu@codeaurora.org>
_

Patches currently in -mm which might be from zijun.hu@oss.qualcomm.com are


