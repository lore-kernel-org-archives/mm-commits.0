Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7213C2AEFD
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 21:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750629016; cv=none; b=dOBiqoCzPigQx1axAVjID229kjXQVuzpODlEoD/CqY/R1G0TEx2R5UhAT30IY+K3dovAdbA7+3e39fubX5s01zOYk7Cob5YJxOhTIffqsmGWs8zw0EKbsW2+AzyyYIakgiKKji3c6r0szswRl4z5SxLpgHm29tHk3c6lZG+IHxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750629016; c=relaxed/simple;
	bh=av/KoTZsDAYa1MgawduGPFcYHPQXAHF5R7FL8/EfTaM=;
	h=Date:To:From:Subject:Message-Id; b=Mlxs0Wm0cU2VzxgBWt4HngafQoKlSP70KsS+4kq+a9/MxEqqn2UbqklsQ8BT4/kWo9s59QNqG/WOOted49TxC4hGt28vT45k+H9zZxvYA0ObnJe44Tlf9TzUv2LZCGoIs5LAM3oCHPWoepMQd6PnM/H2oXGwqt+rseGxJbvf56U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qpVBzKtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qpVBzKtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45367C4CEE3;
	Sun, 22 Jun 2025 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750629016;
	bh=av/KoTZsDAYa1MgawduGPFcYHPQXAHF5R7FL8/EfTaM=;
	h=Date:To:From:Subject:From;
	b=qpVBzKtuyKtCyggd5TGrG64d7jb7779bcgIowKKVQbTPvuHZlKxzlirN2FMRdCSAh
	 B0hIfZ8ANQn3374TAujpnWUKQM0byY8GgpjhbmMEsHih1pp8j2+LEEw2xG23nTGtoI
	 fduI3JGJGjx6K04GO4zdUFT4b0+IO59ucd6GR7zs=
Date: Sun, 22 Jun 2025 14:50:15 -0700
To: mm-commits@vger.kernel.org,hverkuil@xs4all.nl,zijun.hu@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-zijun-hu.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622215016.45367C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entries for Zijun Hu
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-zijun-hu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-zijun-hu.patch

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
@@ -827,3 +827,5 @@ Yosry Ahmed <yosry.ahmed@linux.dev> <yos
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
 Zhu Yanjun <zyjzyj2000@gmail.com> <yanjunz@nvidia.com>
+Zijun Hu <zijun.hu@oss.qualcomm.com> <quic_zijuhu@quicinc.com>
+Zijun Hu <zijun.hu@oss.qualcomm.com> <zijuhu@codeaurora.org>
_

Patches currently in -mm which might be from zijun.hu@oss.qualcomm.com are

mailmap-add-entries-for-zijun-hu.patch
mailmap-correct-name-for-a-historical-account-of-zijun-hu.patch

