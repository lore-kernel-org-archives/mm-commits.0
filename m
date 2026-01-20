Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6F0320385
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 16:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768927498; cv=none; b=LX4ppsiaYrLzJ1BViAELzM3lym9JFAcHDWQGxolp6BZ3NTHOf4v4g+bWabr2+w6UYHnIz9Oa6fthLXsfOXY7kVSruqZusGnQYTWavoNOGjpsLzDhWT816vTe5IJdDQmIIq5DFCmd5IAK6Zd9GcSQwW4lNPYxz6bpyO1sA27ABC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768927498; c=relaxed/simple;
	bh=qI39VUaLh53QCT6mkMXxbWr18G/YNfGHPnBGXk+XRXY=;
	h=Date:To:From:Subject:Message-Id; b=m9w90T1BvVvNMyAI0vAB83n6Gdf4hnMeLWmWE3WxBUjGb2U90a6uPCIPjg6eU/KY2vPXAl85n7d2WPG+QOBz7BzNHaZW4A8hUKqb0IEa1zR8U7pNQW5Cquq+Z/djO4k/iIo/J0q1ST1A0BNiS/sfB7AUpvkR623sELEKdEOsXsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x31ZzbUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x31ZzbUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2FAC16AAE;
	Tue, 20 Jan 2026 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768927497;
	bh=qI39VUaLh53QCT6mkMXxbWr18G/YNfGHPnBGXk+XRXY=;
	h=Date:To:From:Subject:From;
	b=x31ZzbUfU7cd+kOgoAkQR/f6DoD6gCZTzfyuZ3OJ6eHkCPldMNGnjP76/ngqE4bJt
	 0+zcaW0+KHxY+LJjXrE2S2C3uCW5C4iGz40Hvsgydjhnpb6uNQw/veTXZxuudJiWkC
	 Hn4t4bJaB+FXnijE1HZKdm15fA/2JHwHOfsCsZ5w=
Date: Tue, 20 Jan 2026 08:44:56 -0800
To: mm-commits@vger.kernel.org,adeep@lexina.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-viacheslav-bocharov.patch added to mm-hotfixes-unstable branch
Message-Id: <20260120164457.5A2FAC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Viacheslav Bocharov
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-viacheslav-bocharov.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-viacheslav-bocharov.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Viacheslav Bocharov <adeep@lexina.in>
Subject: mailmap: add entry for Viacheslav Bocharov
Date: Tue, 20 Jan 2026 11:21:59 +0300

Map my address <adeep@lexina.in> to new personal address <v@baodeep.com>
Old domain lexina.in will no longer be accessible due to registration
expiration.

Link: https://lkml.kernel.org/r/20260120082212.364268-1-adeep@lexina.in
Signed-off-by: Viacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-viacheslav-bocharov
+++ a/.mailmap
@@ -850,6 +850,7 @@ Valentin Schneider <vschneid@redhat.com>
 Veera Sundaram Sankaran <quic_veeras@quicinc.com> <veeras@codeaurora.org>
 Veerabhadrarao Badiganti <quic_vbadigan@quicinc.com> <vbadigan@codeaurora.org>
 Venkateswara Naralasetty <quic_vnaralas@quicinc.com> <vnaralas@codeaurora.org>
+Viacheslav Bocharov <v@baodeep.com> <adeep@lexina.in>
 Vikash Garodia <vikash.garodia@oss.qualcomm.com> <vgarodia@codeaurora.org>
 Vikash Garodia <vikash.garodia@oss.qualcomm.com> <quic_vgarodia@quicinc.com>
 Vincent Mailhol <mailhol@kernel.org> <mailhol.vincent@wanadoo.fr>
_

Patches currently in -mm which might be from adeep@lexina.in are

mailmap-add-entry-for-viacheslav-bocharov.patch

