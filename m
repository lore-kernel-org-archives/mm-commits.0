Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C37D1D5CD4
	for <mm-commits@vger.kernel.org>; Fri, 24 Jan 2025 06:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737700509; cv=none; b=I3o6qK+eIzYM40V1uz+T6vADNGhd3w3aV2euE3y4c0GdtiBlgrUKs+kICr4jNftbq6ckgjf1hBw8B6IKJjL4yV+0VmhuYVhsE2lc+iJ6yNUqB4I8WsYKwFPuWdhvlK+Lywejf2JlBaFWhaQzB2xh7yCadTGskDiUWbZrbuxFLAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737700509; c=relaxed/simple;
	bh=UV3eljxarajmFgIzG94fYeej7WzLmzbHe4G0X1za1fE=;
	h=Date:To:From:Subject:Message-Id; b=ErE25S/er7kmhZCeeLew/Cu2BojXgIeLeq3jyB6qSPT5+tNZDbt9XS+3xYlXEJlzKur/3JmTxNL/rf43JCKeKKJ+rhIpB9FHHKjI7KbMIxK8fKVC6gbPS2h3R6hLkUPhZiqWSeaCiJ8TYFeldWHR4P2lcY6jOeB99BDzFznbYf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BVj4tlnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BVj4tlnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C58C4CED2;
	Fri, 24 Jan 2025 06:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737700508;
	bh=UV3eljxarajmFgIzG94fYeej7WzLmzbHe4G0X1za1fE=;
	h=Date:To:From:Subject:From;
	b=BVj4tlnGqINAVYN1buZNeoBlDnXlYXdwkesaar9tn2RyaWCWk0lxA180XJx+wph/7
	 ZYpmXt18l9pA9m32zLTW4hM9P+hCxHpJjsk3mOe7ds946tdi+H5qzeO7SjZylHg4/F
	 nBeh/Jg1GyIQC26PttVRsy3CdUpHDajNJMRTPXxg=
Date: Thu, 23 Jan 2025 22:35:08 -0800
To: mm-commits@vger.kernel.org,matttbe@kernel.org,hverkuil@xs4all.nl,davem@davemloft.net,hamzamahfooz@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-an-entry-for-hamza-mahfooz.patch added to mm-hotfixes-unstable branch
Message-Id: <20250124063508.C3C58C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add an entry for Hamza Mahfooz
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-an-entry-for-hamza-mahfooz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-an-entry-for-hamza-mahfooz.patch

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
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Subject: mailmap: add an entry for Hamza Mahfooz
Date: Mon, 20 Jan 2025 15:56:59 -0500

Map my previous work email to my current one.

Link: https://lkml.kernel.org/r/20250120205659.139027-1-hamzamahfooz@linux.microsoft.com
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hans verkuil <hverkuil@xs4all.nl>
Cc: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-an-entry-for-hamza-mahfooz
+++ a/.mailmap
@@ -255,6 +255,7 @@ Guo Ren <guoren@kernel.org> <ren_guo@c-s
 Guru Das Srinagesh <quic_gurus@quicinc.com> <gurus@codeaurora.org>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
 Gustavo Padovan <padovan@profusion.mobi>
+Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> <hamza.mahfooz@amd.com>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Hans Verkuil <hverkuil@xs4all.nl> <hansverk@cisco.com>
 Hans Verkuil <hverkuil@xs4all.nl> <hverkuil-cisco@xs4all.nl>
_

Patches currently in -mm which might be from hamzamahfooz@linux.microsoft.com are

mailmap-add-an-entry-for-hamza-mahfooz.patch

