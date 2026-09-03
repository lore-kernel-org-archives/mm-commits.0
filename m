Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036793769EB
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788459958; cv=none; b=p/V32Dovxr8Ur0GpL8wYvbq85K9eBRWllVYmvOL/upD4PPApOp0IEQii35Oz9pJcgtqCn5Gx2vixlA/oQxKMSztfrJ6xYzbvZ1Fjt9YpSZuEPF2THPvlry0xIDy09Al4Ua5SkhfOfk5qB8WMvsXFxsQhGeszaWOxSUy+vx1bbko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788459958; c=relaxed/simple;
	bh=Br/OKkV5nEvHxn4+cD/8C1JOimiO9dNcbh8GAST5R4w=;
	h=Date:To:From:Subject:Message-Id; b=FKJ4riZCRP29yLug2Ko2+MARNFg6LPLEPf6z64c5wiJwmK2nt0sZxyiQUfTAbKh9xe0PKvQw6d3GA+Qyg3J/C+CSvm/eBQavPJp2oG5DJ+sPyrOr9khNiDqnjwOU+cvpVpX9XWmL7ddyEvLcUSolx/RjWp/Wyb6tx3dL91/whHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FMD6EU5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FMD6EU5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592BE1F000E9;
	Thu,  3 Sep 2026 18:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788459949;
	bh=+yfmeSCJbNadlxbZLsNM7xHtoo/J42EH987cYOJtbek=;
	h=Date:To:From:Subject;
	b=FMD6EU5VxvU9bXU8HPrm1KWX43PKXlux7+m2FMPjjwLiOfMlfetv1a3jf2zt9nDbk
	 cDsnkAoRvRJEMKy/n/6OPewjP8+35x6IpY4pwGBRkF9YUHl7hMIL5ADphdhIZ9vU8i
	 hMIqb7qoPK67Heyux3chapgLLRbSdx/1VQ+Kum0g=
Date: Thu, 03 Sep 2026 11:25:48 -0700
To: mm-commits@vger.kernel.org,calvin.bai@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-haowen-bais-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260903182549.592BE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Haowen Bai's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-haowen-bais-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-haowen-bais-email-address.patch

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
From: Haowen Bai <calvin.bai@ugreen.com>
Subject: mailmap: update Haowen Bai's email address
Date: Thu, 3 Sep 2026 21:28:54 +0800

Map Haowen Bai's former Meizu and current Ugreen addresses to
baihaowen88@gmail.com as the canonical public address.

Link: https://lore.kernel.org/20260903132854.1930923-1-calvin.bai@ugreen.com
Signed-off-by: Haowen Bai <calvin.bai@ugreen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-haowen-bais-email-address
+++ a/.mailmap
@@ -354,6 +354,8 @@ Hans Verkuil <hverkuil@kernel.org> <hver
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
 Hans Verkuil <hverkuil@kernel.org> <hans.verkuil@cisco.com>
 Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
+Haowen Bai <baihaowen88@gmail.com> <baihaowen@meizu.com>
+Haowen Bai <baihaowen88@gmail.com> <calvin.bai@ugreen.com>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
 Harry Yoo <harry@kernel.org> <harry.yoo@oracle.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
_

Patches currently in -mm which might be from calvin.bai@ugreen.com are

mailmap-update-haowen-bais-email-address.patch

