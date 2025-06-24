Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A9447F4A
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 21:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799985; cv=none; b=WEqx/9j5of0rHNUNbipRNRI0uMNB31fNBpH7OwDq9sJZG+NnhODKrlkWHZ1wAiN0fYDs2+Fy1XxvAvb7psU9H3+FpXu2m81/jjmTnR0XFoXryvh1NqXNMeQRQSd5O2EzO4aEISEg1W901J6DA7qy/SIhMrhzmfeMVJhlLM4UC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799985; c=relaxed/simple;
	bh=Jmg/iludWmfTtaA8b1UmEtM8kvHdPUAi17uOXweKtD8=;
	h=Date:To:From:Subject:Message-Id; b=tf6+9gJw5rL8aNgtc6nmIge714QW88WT2J0wujH9QbjFbUOjmP45w3tq2FRt+cElvpWIihhQSero/9wjuzt/8kYEAokdb3NPJuRYj5m9lLapEZsBdWmt1S86gL23iMgoKKuv6CHRQ72WY1TgiEB3QtLC8xyhPW/PzNpPQCwvPUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bM6Yhw9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bM6Yhw9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A12C4CEE3;
	Tue, 24 Jun 2025 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750799984;
	bh=Jmg/iludWmfTtaA8b1UmEtM8kvHdPUAi17uOXweKtD8=;
	h=Date:To:From:Subject:From;
	b=bM6Yhw9vclzHHbVU5/m95vGMJ5qAXea57tYIARbm4qLWgyYdawH+qkule6qflLWHC
	 iw1PmkiXmqIk+oe88nX/qeNzlnZ/YuCMloV6sHNzr1Q7u0MUs7HoHmsQvDgKZ+4a8p
	 THPiNosSiwC5GzxFFy/9BEB076k4y3Ei/v8zz80E=
Date: Tue, 24 Jun 2025 14:19:44 -0700
To: mm-commits@vger.kernel.org,sachin.mokashi@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-sachin-mokashis-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20250624211944.A4A12C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Sachin Mokashi's email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-sachin-mokashis-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-sachin-mokashis-email-address.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sachin Mokashi <sachin.mokashi@intel.com>
Subject: mailmap: update Sachin Mokashi's email address
Date: Tue, 24 Jun 2025 10:12:20 -0400

As previous contributions were made with the older email address, which is
no longer in use.  Update my new address to map the old one.

Link: https://lkml.kernel.org/r/20250624141220.1264691-1-sachin.mokashi@intel.com
Signed-off-by: Sachin Mokashi <sachin.mokashi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-sachin-mokashis-email-address
+++ a/.mailmap
@@ -669,6 +669,7 @@ Muchun Song <muchun.song@linux.dev> <smu
 Ross Zwisler <zwisler@kernel.org> <ross.zwisler@linux.intel.com>
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
+Sachin Mokashi <sachin.mokashi@intel.com> <sachinx.mokashi@intel.com>
 Sachin P Sant <ssant@in.ibm.com>
 Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
_

Patches currently in -mm which might be from sachin.mokashi@intel.com are

mailmap-update-sachin-mokashis-email-address.patch

