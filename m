Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3401EC46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 11:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjAJLw4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 06:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjAJLwz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 06:52:55 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6B9B840
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 03:52:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id E4920604F1;
        Tue, 10 Jan 2023 12:52:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673351572; bh=05r2yIhlj5xCCnXTFiL/81qvcmap2qWYL3sDrVxQPBk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=cBCRz/bzx+XaP1Sf/IVC0ReedNl1/V8pxubcLOMjCNZW5N1IzDLIYgZHvJa2N0ato
         ms1U4pJZeFF1HzJdIhc9wKa6dre/7HddC5B8r7PbZ1QsuPRaJtpirrWkhiSDxvAUle
         2x1B96vkgVcG3Syks9XQAcaQR+BL9O7c067goOmeTK5l9Lce4E+oLIyLqMcl/Unbos
         MCo9MPQgKdr0PphTHYb/TiEsr5XePU549AWRg0AcgVjbkTZWj54VCVa7iz/6uscmx7
         1Z/9XGw3EBYTle8kRyNKayG9hVa+nt7hG6f/c/cVQDJXKwRpyQ/FoOhvgsWOdCTP8D
         y8WU/xTpZMewQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2idvUWR02ooM; Tue, 10 Jan 2023 12:52:50 +0100 (CET)
Received: from [193.198.186.200] (pc-mtodorov.slava.alu.hr [193.198.186.200])
        by domac.alu.hr (Postfix) with ESMTPSA id 1FC42604F0;
        Tue, 10 Jan 2023 12:52:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673351570; bh=05r2yIhlj5xCCnXTFiL/81qvcmap2qWYL3sDrVxQPBk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=bGynKHAYsqi5+0JFN1kO8HyKzOkqOpg3NuQHu03i5y9aA03I7KwuzzkSD8ItCouyE
         Tuy43MIaqh/0d6ukUcjbjWenKaXUnHJuTm+l24+mX3k/FpXmObSaPmGNJGdr/n6RIU
         UiKG//m8KLd/DoKjTq3n+Cr6rIUL8jJhZ3Jop5vJRB4G7xHVhqcJWS55KfoUnyV4MW
         0secuzSAg/hd1jyb8QYejzGeE/SZJDY0iVk7RUAqHhaw8DrwoYD6DcdvLM9/YBV+B2
         eZgZdUMuoJbPVgyzm3Av0pUnEf068+b6hiwTklcwQnsDPV+cw4M5xGWrDtO+Z30y+M
         n3NY61wTAmWsA==
Message-ID: <edb402df-c0df-00d7-3bf4-884c5ba47ca9@alu.unizg.hr>
Date:   Tue, 10 Jan 2023 12:52:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: +
 selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch added to
 mm-unstable branch
Content-Language: en-US, hr
To:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, shuah@kernel.org
References: <20230109233601.C4082C433EF@smtp.kernel.org>
 <cb32e13b-2edd-8a4d-dfc1-779d03a1ff67@alu.unizg.hr>
 <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
From:   Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <5c273641-1a06-f595-59d7-b338f2183953@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 1/10/23 12:18, David Hildenbrand wrote:
> On 10.01.23 12:00, Mirsad Todorovac wrote:
>> Hi,
>>
>> On 1/10/23 00:36, Andrew Morton wrote:
>>> The patch titled
>>>        Subject: selftests/mm: define MADV_PAGEOUT to fix compilation 
>>> issues
>>> has been added to the -mm mm-unstable branch.  Its filename is
>>>        selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>
>>> This patch will shortly appear at
>>>        
>>> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>>>
>>> This patch will later appear in the mm-unstable branch at
>>>       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>>
>>> Before you just go and hit "reply", please:
>>>      a) Consider who else should be cc'ed
>>>      b) Prefer to cc a suitable mailing list as well
>>>      c) Ideally: find the original patch on the mailing list and do a
>>>         reply-to-all to that, adding suitable additional cc's
>>>
>>> *** Remember to use Documentation/process/submit-checklist.rst when 
>>> testing your code ***
>>>
>>> The -mm tree is included into linux-next via the mm-everything
>>> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>> and is updated there every 2-3 working days
>>>
>>> ------------------------------------------------------
>>> From: David Hildenbrand <david@redhat.com>
>>> Subject: selftests/mm: define MADV_PAGEOUT to fix compilation issues
>>> Date: Mon, 9 Jan 2023 18:12:55 +0100
>>>
>>> If MADV_PAGEOUT is not defined (e.g., on AlmaLinux 8), compilation will
>>> fail.  Let's fix that like khugepaged.c does by conditionally defining
>>> MADV_PAGEOUT.
>>>
>>> Link: https://lkml.kernel.org/r/20230109171255.488749-1-david@redhat.com
>>> Fixes: 69c66add5663 ("selftests/vm: anon_cow: test COW handling of 
>>> anonymous memory")
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>> Cc: Shuah Khan <shuah@kernel.org>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>
>>>    tools/testing/selftests/mm/cow.c |    3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> --- 
>>> a/tools/testing/selftests/mm/cow.c~selftests-mm-define-madv_pageout-to-fix-compilation-issues
>>> +++ a/tools/testing/selftests/mm/cow.c
>>> @@ -30,6 +30,9 @@
>>>    #include "../kselftest.h"
>>>    #include "vm_util.h"
>>> +#ifndef MADV_PAGEOUT
>>> +#define MADV_PAGEOUT 21
>>> +#endif
>>>    #ifndef MADV_COLLAPSE
>>>    #define MADV_COLLAPSE 25
>>>    #endif
>>> _
>>>
>>> Patches currently in -mm which might be from david@redhat.com are
>>>
>>> mm-hugetlb-fix-pte-marker-handling-in-hugetlb_change_protection.patch
>>> mm-hugetlb-fix-uffd-wp-handling-for-migration-entries-in-hugetlb_change_protection.patch
>>> mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
>>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range.patch
>>> mm-userfaultfd-rely-on-vma-vm_page_prot-in-uffd_wp_range-fix.patch
>>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection.patch
>>> mm-mprotect-drop-pgprot_t-parameter-from-change_protection-fix.patch
>>> selftests-vm-cow-add-cow-tests-for-collapsing-of-pte-mapped-anon-thp.patch
>>> mm-nommu-factor-out-check-for-nommu-shared-mappings-into-is_nommu_shared_mapping.patch
>>> mm-nommu-dont-use-vm_mayshare-for-map_private-mappings.patch
>>> drivers-misc-open-dice-dont-touch-vm_mayshare.patch
>>> selftests-mm-define-madv_pageout-to-fix-compilation-issues.patch
>> Please consider alternative patch instead. I am submitting it for a
>> review.
>>
>> It would give the referential integrity to the source of the selftest/vm
>> subtree.
>>
>> #ifdef ... #endif encapsulation around `#define __USE_GNU` eliminates a
>> warning.
>>
>> RATIONALE:
>>
>> Though it is ulikely that the values of MADV_PAGEOUT,
>> MADV_POPULATE_READ and MADV_COLLAPSE will change, the source integrity
>> would benefit from having it changed in only one place,
>> .../usr/include/asm-generic/mman-common.h, included by >
>> #include <linux/mman.h>
> 
> Would that imply that we're taking the in-tree sources and not the 
> installed kernel headers?
> 
> Because compilation would fail if the installed kernel headers don't 
> define these.

It seems that userfaultfd.c already included <linux/mman.h>,
so nothing is lost or gained in compilation successes, except that
things look more uniform, coherent and consistent?

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
