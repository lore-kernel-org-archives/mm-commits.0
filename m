Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB172192E6
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686441; cv=none; b=VptV92EU14sDhPd6rKWXFgVLv/+Qzu5xfUs+owsfYJwfYX1klBKQA+Fxaaq2gQ7dVE92UBKvfwxyRRHqKF1ZuhBCXC1qC4NOfUCFb/3uryVDq5gSAb460C74ogE4ai0Kq0j0JIwZdPT5fkFhG08U6awLhOU+xGCZSOmtuTi+pwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686441; c=relaxed/simple;
	bh=chXASm2l0fkj9N3JPKkVseHS/nhPPgBPgl8F8+vPY8Q=;
	h=Date:To:From:Subject:Message-Id; b=D7yQH1bNlC00MqQjjKKCKK+QTMB6C5SakQjDH4H9ti3SF/9Fw8yNYsfW27kLGQjKMNFd4v31caMcryte8rmnVMkCUdpLtyrd4wy91lcp8ldF0Bx07jzz4eLm6ScjeKBnlFdyTgcn1X9pLwaCWFdw2XIKYB2mY3Xd7CJDzcqA2D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VmM4ppRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VmM4ppRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D4FC4CEEB;
	Thu,  8 May 2025 06:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686440;
	bh=chXASm2l0fkj9N3JPKkVseHS/nhPPgBPgl8F8+vPY8Q=;
	h=Date:To:From:Subject:From;
	b=VmM4ppRFBBGo1I6WdmK17pgazElGYDsPMmY0ka/7gc6c0ZCokWw2y+IMHmYZh3ZqU
	 cTYiNBpSsLfo3Qzk78Mh/YE6KkzFoNwoqTY0sAt1CxdjyXFxCsR5aJq2Tvr+dbg1Wf
	 WxVlxK9+rMVt1tz5tcutVsbW3aKtnqs2z0jeZj0U=
Date: Wed, 07 May 2025 23:40:40 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-lance-yang.patch removed from -mm tree
Message-Id: <20250508064040.C3D4FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entries for Lance Yang
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-lance-yang.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <ioworker0@gmail.com>
Subject: mailmap: add entries for Lance Yang
Date: Thu, 17 Apr 2025 23:30:41 +0800

I'm moving to @linux.dev and mapping my old addresses to it.

Link: https://lkml.kernel.org/r/20250417153041.38977-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-lance-yang
+++ a/.mailmap
@@ -447,6 +447,8 @@ Luca Ceresoli <luca.ceresoli@bootlin.com
 Luca Weiss <luca@lucaweiss.eu> <luca@z3ntu.xyz>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Luo Jie <quic_luoj@quicinc.com> <luoj@codeaurora.org>
+Lance Yang <lance.yang@linux.dev> <ioworker0@gmail.com>
+Lance Yang <lance.yang@linux.dev> <mingzhe.yang@ly.com>
 Maciej W. Rozycki <macro@mips.com> <macro@imgtec.com>
 Maciej W. Rozycki <macro@orcam.me.uk> <macro@linux-mips.org>
 Maharaja Kennadyrajan <quic_mkenna@quicinc.com> <mkenna@codeaurora.org>
_

Patches currently in -mm which might be from ioworker0@gmail.com are

hung_task-replace-blocker_mutex-with-encoded-blocker.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-semaphore.patch

