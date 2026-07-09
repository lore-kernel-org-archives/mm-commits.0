Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF91638758E
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 23:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783638909; cv=none; b=KQaPJFQnNNe8lrKR72kjkL7igr4zB5t4xIogYz5svQ2uH/qiJhKKfqYsyydRzaXznO9cMn7snmQSl+NEdY14JB5V/K4WpY4NqSkjIJZF4FxAkBIvZXQ61bkKlSj4rSfiEhG49Uw1WW1MtaBoQRL0abn2MdDLqLOAmcphxjMGA9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783638909; c=relaxed/simple;
	bh=XK2uiuXsb+0dy00xci8u/mHkPTHcyA4P61KrT735IYc=;
	h=Date:To:From:Subject:Message-Id; b=o4wq7Zh791N4xritAkOsemmzJUlsnSvTKLwFOqwKqU8TrqJ8Sbj9tOM4bdk41g4Aeovpc5C4N1UYDgEMlZq68xheURk+sVZ8TsuhmPV7DpVcEJtjG98V2FqUfEQextFSPThhGHONH9Z7T6bcCZCunx6MEp3cdT64CLt9vm5Bjp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=icjc3nU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="icjc3nU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C09B1F000E9;
	Thu,  9 Jul 2026 23:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783638907;
	bh=p0QzQ4gvwVtOFsNKOVq2mcerUpN1l35w8M3pmc+QX0Y=;
	h=Date:To:From:Subject;
	b=icjc3nU7UHPaHpavjiUzrhx7yZR0ANX7nP2r1OAzUDFyCagrOjsEjEX7npm4q/21H
	 RNRDt7jxNi7mIA7x5gkhgZrMNNujOOppkYrAOYh9fBEPKe+GVDJknVqeTaLwZ8dLjA
	 lBfYBoDobj7n6N1MYlOwjEgTu0Y3rD/AJkqLXgMw=
Date: Thu, 09 Jul 2026 16:15:06 -0700
To: mm-commits@vger.kernel.org,pjw@kernel.org,thecharlesjenkins@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-charlie-jenkins.patch added to mm-nonmm-unstable branch
Message-Id: <20260709231507.5C09B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for Charlie Jenkins
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entry-for-charlie-jenkins.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-charlie-jenkins.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: mailmap: add entry for Charlie Jenkins
Date: Thu, 09 Jul 2026 00:31:04 -0700

My Rivos email started bouncing so redirect to my personal email.

Link: https://lore.kernel.org/20260709-mailmap-v1-1-74d98b8149d6@gmail.com
Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Cc: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-charlie-jenkins
+++ a/.mailmap
@@ -185,6 +185,7 @@ Carlos Bilbao <carlos.bilbao@kernel.org>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
 Chao Yu <chao@kernel.org> <yuchao0@huawei.com>
+Charlie Jenkins <thecharlesjenkins@gmail.com> <charlie@rivosinc.com>
 Chen-Yu Tsai <wens@kernel.org> <wens@csie.org>
 Chester Lin <chester62515@gmail.com> <clin@suse.com>
 Chris Chiu <chris.chiu@canonical.com> <chiu@endlessm.com>
_

Patches currently in -mm which might be from thecharlesjenkins@gmail.com are

mailmap-add-entry-for-charlie-jenkins.patch

