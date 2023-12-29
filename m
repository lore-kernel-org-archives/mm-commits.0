Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C5413FE1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CYS0Dq4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB00C433CA;
	Fri, 29 Dec 2023 20:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881401;
	bh=zK+4nE0KTRYdblzP6396n50bqu8im24wJMztoUcJhqE=;
	h=Date:To:From:Subject:From;
	b=CYS0Dq4fOleAVUomIamuCjUPAdnV28KHwQgVg8bAjRRjplcCghBh5mjtrnrJOlw1h
	 Li3zzMxoOf1H7FJJF1G1CpcP6+o8qomH2mKk7UE3QGLF9zwHhxwKq5NwgHsN0jTv74
	 Kv3bLVqsyswRJai/sW9Wgu88y46pBaa+wO1XKtc0=
Date: Fri, 29 Dec 2023 12:23:20 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,yangtiezhu@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-submit-checklist-remove-all-of-make-namespacecheck.patch removed from -mm tree
Message-Id: <20231229202321.6CB00C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: submit-checklist: remove all of "make namespacecheck"
has been removed from the -mm tree.  Its filename was
     docs-submit-checklist-remove-all-of-make-namespacecheck.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: docs: submit-checklist: remove all of "make namespacecheck"
Date: Tue, 19 Dec 2023 20:50:01 +0800

After commit 7dfbea4c468c ("scripts: remove namespace.pl"),
scripts/namespace.pl has been removed from the kernel, and "make
namespacecheck" has been removed from the English version of
submit-checklist.rst, so also remove it in the related translations.

Link: https://lkml.kernel.org/r/20231219125008.23007-6-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/translations/ja_JP/SubmitChecklist              |    4 ++--
 Documentation/translations/zh_CN/process/submit-checklist.rst |    3 +--
 Documentation/translations/zh_TW/process/submit-checklist.rst |    3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

--- a/Documentation/translations/ja_JP/SubmitChecklist~docs-submit-checklist-remove-all-of-make-namespacecheck
+++ a/Documentation/translations/ja_JP/SubmitChecklist
@@ -56,8 +56,8 @@ などのLinuxカーネルパッチ投�
 
  9: sparseを利用してちゃんとしたコードチェックをしてください。
 
-10: 'make checkstack' と 'make namespacecheck' を利用し、問題が発見されたら
-    修正してください。'make checkstack' は明示的に問題を示しませんが、どれか
+10: 'make checkstack' を利用し、問題が発見されたら修正してください。
+    'make checkstack' は明示的に問題を示しませんが、どれか
     １つの関数が512バイトより大きいスタックを使っていれば、修正すべき候補と
     なります。
 
--- a/Documentation/translations/zh_CN/process/submit-checklist.rst~docs-submit-checklist-remove-all-of-make-namespacecheck
+++ a/Documentation/translations/zh_CN/process/submit-checklist.rst
@@ -53,8 +53,7 @@ 和其他有关提交Linux内核补丁�
 9) 通过 sparse 清查。
    （参见 Documentation/translations/zh_CN/dev-tools/sparse.rst ）
 
-10) 使用 ``make checkstack`` 和 ``make namespacecheck`` 并修复他们发现的任何
-    问题。
+10) 使用 ``make checkstack`` 并修复他们发现的任何问题。
 
     .. note::
 
--- a/Documentation/translations/zh_TW/process/submit-checklist.rst~docs-submit-checklist-remove-all-of-make-namespacecheck
+++ a/Documentation/translations/zh_TW/process/submit-checklist.rst
@@ -56,8 +56,7 @@ 和其他有關提交Linux內核補丁�
 9) 通過 sparse 清查。
    （參見 Documentation/translations/zh_CN/dev-tools/sparse.rst ）
 
-10) 使用 ``make checkstack`` 和 ``make namespacecheck`` 並修復他們發現的任何
-    問題。
+10) 使用 ``make checkstack`` 並修復他們發現的任何問題。
 
     .. note::
 
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


