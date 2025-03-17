Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D732FB2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189487; cv=none; b=AO+XbtmmruXq+cQwxCD2VhxReiC88r908BDTJWNYaggaW6jxTGvYXxZtGZ4S3FwiJqe5YTpbevn/ntc472AcqC/tuUqqULT2D4L2SvJrypIKFNnfjkjcA09nRYB7LTXuM0iXPaAr67TMb8IwEm8/miujYbmg3FB0pQdKzGfDGGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189487; c=relaxed/simple;
	bh=92EqX8UytdXyY4bGS1yo2eUP5hig9/IPBWDCc5vyX44=;
	h=Date:To:From:Subject:Message-Id; b=EfGUZH2b8VJyHzPJZl1jatK2NXhOE3l38FDlp7BrjWulczaZDNuqzKMoLiaIsYxjal4GMdAgqko1Eodw7dazoMfGRgr/v/o+E2Z07j3h2KZkeaiUvk5tP6a3zMFxE/fLliaF15Ph9vlbRDM/gTqVqnu3iB8GTqC8r47bw51XhzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LlXB5Brs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LlXB5Brs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF07C4CEEC;
	Mon, 17 Mar 2025 05:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189487;
	bh=92EqX8UytdXyY4bGS1yo2eUP5hig9/IPBWDCc5vyX44=;
	h=Date:To:From:Subject:From;
	b=LlXB5BrsRPQy80VdHTo+0VZeAD2mT3xV1d/n10zRpSCesNdUi7WLennsddejrJTnD
	 F2B5n7m4E7EVbm5R/8lBuHNW5ypgzUCC+bgzZgzqx6IRR0VDMV5i5jzyWKCWP0puqj
	 n+ssQDFUI+eck74CwxloE80eLJDrvKOUJGZgTYH8=
Date: Sun, 16 Mar 2025 22:31:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,corbet@lwn.net,carlos.bilbao@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-remove-redundant-mappings-of-emails.patch removed from -mm tree
Message-Id: <20250317053126.DFF07C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: remove redundant mappings of emails
has been removed from the -mm tree.  Its filename was
     mailmap-remove-redundant-mappings-of-emails.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Bilbao <carlos.bilbao@kernel.org>
Subject: .mailmap: remove redundant mappings of emails
Date: Tue, 28 Jan 2025 19:34:30 -0600

Remove two redundant mappings:
changbin.du@intel.com -> changbin.du@intel.com
viresh.kumar@linaro.org -> viresh.kumar@linaro.org

Link: https://lkml.kernel.org/r/20250129013430.1117720-1-carlos.bilbao@kernel.org
Signed-off-by: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 --
 1 file changed, 2 deletions(-)

--- a/.mailmap~mailmap-remove-redundant-mappings-of-emails
+++ a/.mailmap
@@ -153,7 +153,6 @@ Carlos Bilbao <carlos.bilbao@kernel.org>
 Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao.osdev@gmail.com>
 Carlos Bilbao <carlos.bilbao@kernel.org> <bilbao@vt.edu>
 Changbin Du <changbin.du@intel.com> <changbin.du@gmail.com>
-Changbin Du <changbin.du@intel.com> <changbin.du@intel.com>
 Chao Yu <chao@kernel.org> <chao2.yu@samsung.com>
 Chao Yu <chao@kernel.org> <yuchao0@huawei.com>
 Chester Lin <chester62515@gmail.com> <clin@suse.com>
@@ -757,7 +756,6 @@ Vinod Koul <vkoul@kernel.org> <vkoul@inf
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar2@arm.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.kumar@st.com>
 Viresh Kumar <vireshk@kernel.org> <viresh.linux@gmail.com>
-Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.org>
 Viresh Kumar <viresh.kumar@linaro.org> <viresh.kumar@linaro.com>
 Vishnu Dasa <vishnu.dasa@broadcom.com> <vdasa@vmware.com>
 Vivek Aknurwar <quic_viveka@quicinc.com> <viveka@codeaurora.org>
_

Patches currently in -mm which might be from carlos.bilbao@kernel.org are


